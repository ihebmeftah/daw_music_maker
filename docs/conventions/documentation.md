# Documentation conventions

The product must stay documented as it is built — code docs plus feature docs.

## Code (Flutter + server)

- Every public class, enum, extension, top-level function, public method and public field
  has a `///` dartdoc comment. Explain **what** and **why**, not a restatement of the name.
- Use `[ClassName]` references, document thrown exceptions ("Throws [AppException] with
  [ErrorCode.notFound] when …") and units (ticks, BPM, dB, seconds).
- Shared widgets include a short `/// ```dart` usage example.
- Use `//` comments inside method bodies only for non-obvious logic (audio timing, math,
  security decisions). No commented-out code.
- In `.spy.yaml` models, document the class and **every field** with `###` comments — these
  become dartdoc in the generated server and client code.
- Endpoints: dartdoc each method with its purpose, auth requirement, inputs, return value
  and errors — this is the API reference the client sees.

## Feature docs

- Each feature has `docs/features/<feature>.md` containing:
  1. Purpose and user stories
  2. Screens/routes (Flutter) and endpoints (server) involved
  3. Models: entities, DTOs, responses
  4. Validation rules and security notes
  5. How it is tested
- Update the feature doc in the same change that alters the feature's behavior.
- Keep `AGENTS.md` → "Features" list up to date when a feature is added.
