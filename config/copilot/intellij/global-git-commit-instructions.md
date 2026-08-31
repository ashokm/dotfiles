# Global Git Commit Instructions

Use Conventional Commits format:
`type(scope): description`

## Rules

- Use lowercase type (feat, fix, docs, style, refactor, perf, test, chore)
- Use imperative mood ("add", not "added")
- Do not end subject with a period
- Include scope when helpful (api, ui, auth, db, etc.)
- Keep every commit message line at 100 characters or fewer

## Language and tone

- Use British English spelling and grammar by default.
- Use a natural, human tone; avoid robotic phrasing.
- Keep wording clear and specific; avoid generic AI boilerplate.

## Commit body

- Leave a blank line after the header
- Include at least one body line describing what changed and why
- Use bullet points (*) when useful

## Footer

- Use revert: <type>(<scope>): <subject> for reverts
- Reference issues (Resolves:, Refs:)
- Use BREAKING CHANGE: when applicable

Keep commits atomic and squash unnecessary commits before merge.
