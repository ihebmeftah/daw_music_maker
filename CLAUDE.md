# Claude Code instructions

@AGENTS.md

## Claude-specific notes

- Path-scoped rules in `.claude/rules/` load the matching `docs/conventions/*.md` automatically
  when you touch Flutter, server or test files. Always read the relevant convention file
  before writing code if it is not already in context.
- Use the project skills (`serverpod-*`, `flutter-*`) before writing Serverpod models,
  endpoints, tests, migrations, routing or widget tests.
- MCP servers are configured in `.mcp.json` (`serverpod`, `dart`). Prefer them over the CLI as
  described in AGENTS.md.
- When a feature is implemented, finish the whole checklist in AGENTS.md (tests + docs included)
  before reporting it as done.
