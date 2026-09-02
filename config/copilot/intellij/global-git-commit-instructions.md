# Global Git Commit Instructions

Use Conventional Commits:

`type(scope): description`

* Use lowercase types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`.
* Use imperative mood.
* Do not end the subject with a period.
* Keep every line at 100 characters or fewer.
* Include a scope when useful.

The commit body is required:

* Leave a blank line after the header.
* Include at least one line explaining what changed and why.
* Use `*` bullets when useful.

Use `BREAKING CHANGE:` when applicable.
Use `Resolves:` or `Refs:` for issue references.
For reverts, use `revert: <type>(<scope>): <subject>`.
