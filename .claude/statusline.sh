#!/usr/bin/env bash
# Claude Code status line: reads session JSON on stdin, prints one line.
#
#   ~/code/fredrik/docs │ main +1 !2 ?3 ↑1 wt:name #12 │ Fable 5.2 high │ ctx 23%/200k │ 5h 41% fable 32%
#
# Input schema: https://code.claude.com/docs/en/statusline
# Test: echo '{"workspace":{"current_dir":"'$PWD'"},"model":{"display_name":"X"}}' | ~/.claude/statusline.sh

input=$(cat)

# One jq pass. @sh quotes every value, so the eval is safe.
eval "$(jq -r '
  def pct: if . == null then "" else floor end;
  def size: if . == null then ""
    elif . >= 1000000 then "\(. / 1000000 | floor)M"
    else "\(. / 1000 | floor)k" end;
  @sh "cwd=\(.workspace.current_dir // .cwd // "")",
  @sh "model=\(.model.display_name // .model.id // "")",
  @sh "effort=\(.effort.level // "")",
  @sh "fast=\(.fast_mode // false)",
  @sh "ctx_pct=\(.context_window.used_percentage | pct)",
  @sh "ctx_size=\(.context_window.context_window_size | size)",
  @sh "worktree=\(.workspace.git_worktree // "")",
  @sh "pr_number=\(.pr.number // "")",
  @sh "pr_url=\(.pr.url // "")",
  @sh "pr_state=\(.pr.review_state // "")",
  @sh "limit_5h=\(.rate_limits.five_hour.used_percentage | pct)",
  @sh "limit_7d=\(.rate_limits.seven_day.used_percentage | pct)"
' <<<"$input" 2>/dev/null)"

# Basic 16 colors only, so the line follows the terminal theme.
reset=$'\033[0m' dim=$'\033[2m' bold=$'\033[1m'
red=$'\033[31m' green=$'\033[32m' yellow=$'\033[33m'
blue=$'\033[34m' magenta=$'\033[35m' cyan=$'\033[36m'

# Color for a percentage: green below $2, yellow below $3, red from there.
level() {
  if (($1 >= $3)); then printf %s "$red"
  elif (($1 >= $2)); then printf %s "$yellow"
  else printf %s "$green"; fi
}

segments=()

# --- directory: ~ for $HOME, keep only the last three components when deep
dir=$cwd
[[ $dir == "$HOME"* ]] && dir="~${dir#"$HOME"}"
IFS=/ read -ra parts <<<"$dir"
n=${#parts[@]}
((n > 5)) && dir="…/${parts[n - 3]}/${parts[n - 2]}/${parts[n - 1]}"
segments+=("${bold}${blue}${dir}${reset}")

# --- git: branch, in-progress operation, change counts, ahead/behind, worktree, PR
# --no-optional-locks: never take the index lock, so this cannot collide with
# a git command Claude or I run at the same moment.
if [[ -n $cwd ]] && status=$(git -C "$cwd" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null); then
  read -r branch ahead behind staged unstaged untracked conflicts < <(awk '
    $1 == "#" && $2 == "branch.oid"  { oid = $3 }
    $1 == "#" && $2 == "branch.head" { head = $3 }
    $1 == "#" && $2 == "branch.ab"   { ahead = $3 + 0; behind = -$4 }
    $1 == "1" || $1 == "2" {
      if (substr($2, 1, 1) != ".") staged++
      if (substr($2, 2, 1) != ".") unstaged++
    }
    $1 == "u" { conflicts++ }
    $1 == "?" { untracked++ }
    END {
      if (head == "(detached)") head = "@" substr(oid, 1, 7)
      print head, ahead + 0, behind + 0, staged + 0, unstaged + 0, untracked + 0, conflicts + 0
    }' <<<"$status")

  git_seg="${magenta}${branch}${reset}"

  git_dir=$(git -C "$cwd" rev-parse --absolute-git-dir 2>/dev/null)
  op=
  if [[ -d $git_dir/rebase-merge || -d $git_dir/rebase-apply ]]; then op=rebase
  elif [[ -f $git_dir/MERGE_HEAD ]]; then op=merge
  elif [[ -f $git_dir/CHERRY_PICK_HEAD ]]; then op=cherry-pick
  elif [[ -f $git_dir/REVERT_HEAD ]]; then op=revert
  elif [[ -f $git_dir/BISECT_LOG ]]; then op=bisect
  fi
  [[ -n $op ]] && git_seg+=" ${red}${op}${reset}"

  ((conflicts > 0)) && git_seg+=" ${red}✖${conflicts}${reset}"
  ((staged > 0)) && git_seg+=" ${green}+${staged}${reset}"
  ((unstaged > 0)) && git_seg+=" ${yellow}!${unstaged}${reset}"
  ((untracked > 0)) && git_seg+=" ${dim}?${untracked}${reset}"
  ((ahead > 0)) && git_seg+=" ${cyan}↑${ahead}${reset}"
  ((behind > 0)) && git_seg+=" ${cyan}↓${behind}${reset}"

  [[ -n $worktree ]] && git_seg+=" ${yellow}wt:${worktree}${reset}"

  if [[ -n $pr_number ]]; then
    case $pr_state in
      approved) pr_color=$green ;;
      changes_requested) pr_color=$red ;;
      draft) pr_color=$dim ;;
      *) pr_color=$yellow ;;
    esac
    pr_text="#${pr_number}"
    # OSC 8 hyperlink: cmd-click opens the PR.
    [[ -n $pr_url ]] && pr_text=$'\033]8;;'"${pr_url}"$'\a'"${pr_text}"$'\033]8;;\a'
    git_seg+=" ${pr_color}${pr_text}${reset}"
  fi

  segments+=("$git_seg")
fi

# --- model, effort, fast mode
if [[ -n $model ]]; then
  model_seg="${cyan}${model}${reset}"
  [[ -n $effort ]] && model_seg+=" ${effort}"
  [[ $fast == true ]] && model_seg+=" ${yellow}fast${reset}"
  segments+=("$model_seg")
fi

# --- context window (null until the first response)
if [[ -n $ctx_pct ]]; then
  ctx_seg="ctx $(level "$ctx_pct" 50 80)${ctx_pct}%${reset}"
else
  ctx_seg="ctx ${dim}--${reset}"
fi
[[ -n $ctx_size ]] && ctx_seg+="${dim}/${ctx_size}${reset}"
segments+=("$ctx_seg")

# --- rate limits (subscription only): 5h always, 7d once it is worth knowing
limit_seg=
[[ -n $limit_5h ]] && limit_seg="5h $(level "$limit_5h" 70 90)${limit_5h}%${reset}"
if [[ -n $limit_7d ]] && ((limit_7d >= 50)); then
  limit_seg+="${limit_seg:+ }7d $(level "$limit_7d" 70 90)${limit_7d}%${reset}"
fi

# Model-scoped weekly limit ("Current week (Fable)" in /usage). Claude Code does
# not pass this to the status line, so read its own cache of the /usage data in
# ~/.claude.json. Undocumented and only refreshed now and then: show the age
# once it is over ten minutes old, drop it once the window has reset.
scoped_name='' scoped_pct='' scoped_age=''
eval "$(jq -r --arg model "$model" '
  .cachedUsageUtilization as $cache
  | first(
      ($cache.utilization.limits // [])[]
      | select(.kind == "weekly_scoped")
      | (.scope.model.display_name // "") as $name
      | select($name != "" and ($model | startswith($name)))
      | select((.resets_at | sub("\\.[0-9]+"; "") | sub("\\+00:00$"; "Z") | fromdateiso8601) > now)
      | [ @sh "scoped_name=\($name | ascii_downcase)",
          @sh "scoped_pct=\(.percent | floor)",
          @sh "scoped_age=\(now - ($cache.fetchedAtMs / 1000) | floor)" ]
      | join("\n")
    , empty)
' ~/.claude.json 2>/dev/null)"
if [[ -n $scoped_pct ]]; then
  limit_seg+="${limit_seg:+ }${scoped_name} $(level "$scoped_pct" 70 90)${scoped_pct}%${reset}"
  if ((scoped_age >= 3600)); then limit_seg+="${dim}~$((scoped_age / 3600))h${reset}"
  elif ((scoped_age >= 600)); then limit_seg+="${dim}~$((scoped_age / 60))m${reset}"; fi
fi

[[ -n $limit_seg ]] && segments+=("$limit_seg")

# --- join
sep=" ${dim}│${reset} "
out=${segments[0]}
for seg in "${segments[@]:1}"; do out+="${sep}${seg}"; done
printf '%s\n' "$out"
