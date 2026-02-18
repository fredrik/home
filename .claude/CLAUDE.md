# Claude

Global instructions for Claude.

## Git

- Write commit messages that conform to Tim Pope's standards.
- Include the prompt in the commit message.
- Don't add emojis to commit messages.

- NEVER use `git -C <path>`. Always run git commands without `-C`. You are already in the correct directory. Using `-C` is redundant and wrong.
- When working on a feature branch, use `git worktree add` instead of `git checkout -b`.
