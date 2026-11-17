# CLAUDE

This file provides an overview of Fredrik's home directory.

For dotfiles context, read `~/DOTFILES.md`.

## Code Directory

All source code lives in `~/code/` with this structure:

| Path | Purpose | Remote |
|------|---------|--------|
| `knowit/{project}` | Work projects | `github.com/{employer-org}/{project}` |
| `fredrik/{project}` | Personal projects | `github.com/fredrik/{project}` |
| `sandbox/{project}` | Experiments, POC, scratch | Local (may graduate to `fredrik/` or `knowit/`) |
| `upstream/{owner}/{project}` | Third-party code | `github.com/{owner}/{project}` |

When cloning, place repos according to this convention. Read `~/code/CLAUDE.md` for details.

When Claude generates one-off scripts, put them in `~/code/sandbox/scripts-by-claude`. Two rules apply every time, from whichever project the session runs in:

- Always commit the script there before finishing. Never leave it untracked.
- Always keep the index up to date: add or update the script's row in that repo's `README.md` in the same commit.

Read `~/code/sandbox/scripts-by-claude/CLAUDE.md` first for where the script goes.

## Notes Directory

`~/notes/` is for future-reference material — "how I did it", useful resources, sources found along the way. Markdown files, organized per topic as `{topic}/{note}.md`.

Read `~/notes/CLAUDE.md` before adding a note.

## Research Directory

`~/research/` is for focused Claude research sessions that generate material on a specific topic. Organized per topic as `{topic}/*.md`.
