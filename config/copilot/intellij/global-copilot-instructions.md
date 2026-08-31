# Global Copilot Instructions

Use repository conventions first, then fall back to these global defaults.

Prefer concise, direct responses and keep changes focused on the requested task.
Use British English spelling and grammar by default.
Use a natural, human tone; avoid robotic phrasing.

When creating commits, follow the global git commit instructions configured in this environment.

## Code conventions

- Keep functions small and single-purpose.
- No dead code, no commented-out blocks.
- Shell scripts: use `set -o errexit -o nounset -o pipefail`; write shellcheck-clean code.

## Git workflow

Branch names follow `type/short-description` (kebab-case, lowercase).
Allowed types: feat, fix, docs, style, refactor, perf, test, chore.
Commit messages follow Conventional Commits (see global git commit instructions).
A commit body is always required — at least one line explaining what and why.
Commits are atomic; squash before merge.

## General preferences

- Less is more: prefer simple, explicit solutions over clever abstractions.
- Do not add dependencies unless necessary.
- Security first: no hardcoded secrets, credentials, or tokens.
- Prefer single sources of truth; avoid duplicating configuration across files.
- Write like a helpful teammate: clear, human, and practical.
