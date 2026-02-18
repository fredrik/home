# Claude

Global instructions for Claude.

## Git

- Write commit messages that conform to Tim Pope's standards.
- Include the prompt in the commit message.
- Don't add emojis to commit messages.

- NEVER use `git -C <path>`. Always run git commands without `-C`. You are already in the correct directory. Using `-C` is redundant and wrong.
- When working on a feature branch, use `git worktree add` instead of `git checkout -b`.

## Chapters

Use `/chapter` to start a tracked chapter. Once a chapter log exists in `~/.claude/chapters/`:
- Update the Progress section as tasks complete
- Record key decisions in the Decisions section
- Before the chapter ends, write a Summary and note follow-up items
