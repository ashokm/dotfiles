# Global Agents Instructions

Follow the global git commit instructions in this environment.

Prefer IntelliJ and Copilot settings that apply cleanly across repositories.

Do not rely on project-local AI settings when a global equivalent exists.

## Agent behaviour

- Always confirm destructive actions (file deletion, force push, branch deletion) before executing.
- Do not commit secrets, credentials, tokens, or personally identifiable information.
- When creating branches, follow the `type/short-description` naming convention.
- When creating commits, a body is required — explain what changed and why.
- Prefer targeted, minimal changes over broad rewrites unless explicitly asked.
- If uncertain about scope, ask rather than assume.
- Clean up temporary files and artefacts after task completion.
