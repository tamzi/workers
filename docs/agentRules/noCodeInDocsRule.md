# No Code in Docs Rule

> **For AI Agents:** Do not include code snippets in markdown

## Rule

Markdown documentation must not contain source code snippets. Exception: Mermaid diagrams are
allowed for workflow or architecture visuals and must use `mermaid` fenced blocks. Instead:

- Link to real files and functions.
- Describe behavior and intent in plain language.
- Use commands only when necessary and keep them minimal.

## Why

Code snippets in docs drift from the source of truth and are hard to maintain.
