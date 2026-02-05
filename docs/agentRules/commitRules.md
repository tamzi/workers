# Commit Message Rules

> **For AI Agents:** Git commit message guidelines

## Format

- Subject line in past tense, concise, and without a trailing period.
- Keep the subject under 50 characters when possible.

## Scope

- One logical change per commit.
- One documentation file per commit.
- Split commits by layer or concern when needed.

## Pre-Commit Checklist

- Review actual diffs before committing.
- Ensure tests and checks relevant to the change have run.
- Confirm documentation rules are followed.
- Ensure git hooks are installed and passing (see `scripts/README.md`).
- Verify no secrets or credentials are included.

## Push Rules

AI agents must never run `git push`. Provide the command for a human to run.
