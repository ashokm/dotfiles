# Global Git Commit Instructions

Generate a commit message only. Do not add commentary, code fences, labels, or quotes.

Use this exact Conventional Commits format:

`type(scope): subject`

If scope adds no useful context, use `type: subject`.

Rules:

* Use lowercase types only: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`.
* Start the subject with a lowercase letter.
* Use imperative mood.
* Do not end the subject with a period.
* Keep every line at 100 characters or fewer.
* Include a scope when it adds useful context, using only lowercase letters, digits, `.`, `_`, `-`, `/`.

Body (optional):

* If useful, leave one blank line after the header and explain what changed and why.
* Use `*` bullets when useful.

Use `BREAKING CHANGE:` when applicable.
Use `Resolves:` or `Refs:` for issue references.

For reverts, use:

`revert: <type>(<scope>): <subject>`

Example commit message:

chore(dotfiles): tighten commit message guidance

* align Copilot output with the commit-msg hook
* keep generated commits compliant with the team convention
