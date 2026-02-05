# Documentation Rules

> **For AI Agents:** Documentation organization and structure guidelines

## Core Rules

1. Be concise and specific.
2. Keep docs in `docs/` (except module READMEs).
3. Module READMEs must be under 100 lines.
4. Use camelCase for markdown files, except `README.md` and `Agents.md`.
5. Update `docs/README.md` when adding new docs.
6. Do not include “Last Updated” dates or maintainer info.
7. No code snippets in markdown; link to real files instead. Exception: Mermaid diagrams are
   allowed for workflow or architecture visuals and must use `mermaid` fenced blocks.

## Writing Guidance

- Prefer plain language over long prose.
- Link to real files rather than duplicating implementation details.
- Keep line length reasonable (80–120 characters).

## Organization

- High-level docs live in `docs/`.
- Keep indexes current and accurate.
- Document new conventions in `docs/agentRules/`.

## Enforcement

- Verify naming and size limits before committing.
- Ensure all links reference real files.
