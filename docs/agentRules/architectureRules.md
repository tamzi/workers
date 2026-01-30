# Architecture Rules

> **For AI Agents:** Architectural boundaries and dependency rules

## Principles

- Keep dependencies flowing one direction.
- Separate pure logic from IO and external services.
- Prefer explicit interfaces at module boundaries.

## Boundaries

- UI/presentation should not depend on data sources directly.
- Domain logic should not depend on platform-specific APIs.
- Infrastructure should be replaceable via interfaces.

## Changes

- Minimize cross-module changes.
- Document new boundaries in `docs/agentRules/` if you introduce them.
