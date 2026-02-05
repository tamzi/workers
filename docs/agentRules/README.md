# AI Agent Rules & Guidelines

> **Purpose:** Centralized rules and guidelines for AI agents working on the repo

## Overview

This directory contains specific rules and guidelines for planning, implementation, review, testing,
and documentation. It is the source of truth for how agents should work in this repository.

## Structure

- `projectOverview.md` - Project context and constraints
- `workflowRules.md` - Planning, execution, review, and summary rules
- `prioritizationRules.md` - Autonomous prioritization criteria
- `thoughtfulCollaboration.md` - Critical thinking and collaboration guidelines
- `commitRules.md` - Commit message format and pre-commit rules
- `testingRules.md` - Testing standards and expectations
- `featureDevelopmentRules.md` - Feature planning and delivery guidance
- `codingStandards.md` - Code style, naming, and documentation
- `documentationRules.md` - Documentation organization and structure
- `noCodeInDocsRule.md` - No code snippets in markdown (Mermaid diagrams allowed)
- `documentationCleanupPrompt.md` - Cleanup checklist
- `architectureRules.md` - Architecture boundaries and dependency rules

## Quick Reference

- Start with `projectOverview.md` for context and constraints.
- Use `workflowRules.md` for planning, execution, review, and summaries.
- Use `prioritizationRules.md` to decide Next Up vs Backlog.
- Use `thoughtfulCollaboration.md` to challenge assumptions and surface risks.
- Use `commitRules.md` before any commit.
- Use `testingRules.md` before marking work complete.
- Use `codingStandards.md` for naming and documentation requirements.
- Use `documentationRules.md` and `noCodeInDocsRule.md` for doc updates.
- Use `architectureRules.md` when touching boundaries or dependencies.

## Key Guidelines for AI Agents

- Think before acting and challenge assumptions.
- Discuss before implementing when requirements or tradeoffs are unclear.
- Plan before execution and follow the workflow order in `agents/workflows/`.
- Keep changes atomic and focused.
- Review and test before completion.
- Update documentation when behavior changes.
- Ensure a work board exists; if missing, create `docs/tasks/` with the required templates.
- Never push; provide the command for a human to run.

## For Human Developers

These rules serve as onboarding documentation, a reference during development, and a review checklist
for maintainers.

## Priority Order When Rules Conflict

1. Workflow Rules
2. Architecture Rules
3. Testing Rules
4. Commit Rules
5. Coding Standards
6. Feature Development Rules
7. Documentation Rules

## Updating Rules

- Update the relevant file; do not duplicate rules across files.
- Keep references tied to real files and directories.
- Update this README when adding new rule files.
- Keep changes concise and actionable.

## Enforcement

- Run the repo’s configured lint, build, and test checks before commits.
- Perform manual self-review using the checklists in these rules.
