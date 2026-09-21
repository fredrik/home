# Tab/window titles: "<command> — <dir>" while running, "<dir>" when idle.
# Makes Ghostty's Window menu list distinguishable when many tabs share a cwd.
_title_set() { printf '\e]2;%s\a' "$1" }
_title_dir() { print -P '%1~' }
_title_precmd() { _title_set "$(_title_dir)" }
_title_preexec() {
  local cmd=${2%% *}                     # first word of the expanded command
  [[ $cmd == (sudo|env|time|nohup) ]] && cmd=${${2#* }%% *}
  _title_set "$cmd — $(_title_dir)"
}
add-zsh-hook precmd _title_precmd
add-zsh-hook preexec _title_preexec
