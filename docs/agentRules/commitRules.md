# Commit Message Rules

> **For AI Agents:** Git commit message guidelines

## Format

```
<Subject: past tense, concise, no period>
```

## Core Rules

- Use past tense (Added, Fixed, Updated).
- Keep the subject under 50 characters.
- Do not add a trailing period.
- One logical change per commit.
- One documentation file per commit.
- Do not push automatically.

## Pre-Commit Checklist

- Review actual diffs before committing.
- Ensure no secrets are included.
- Ensure doc rules are followed.

## Push Rules

AI agents must never run `git push`. Provide the command for a human to run.
