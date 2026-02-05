# Testing Rules

> **For AI Agents:** Testing standards and expectations

## Expectations

- Add or update tests for all behavior changes.
- Cover edge cases and error paths.
- Keep tests deterministic and isolated from external dependencies.

## Test Types

- Unit tests for logic and pure functions.
- Integration tests for module or service boundaries.
- End-to-end tests when behavior spans multiple layers.

## Coverage

- Meet the repository’s coverage target.
- If no target is defined, aim for strong coverage on new or changed code.

## Execution

- Run the relevant test commands defined by the repo.
- Report failures and fix before completing work.

## Test Data

- Use fixtures or builders for clarity and reuse.
- Avoid brittle or environment-specific data.
