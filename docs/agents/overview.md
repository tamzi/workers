# Agents Overview

Dev-time agent configuration for use with Cursor and Firebender.

## Locations

- Agent registry: `agents/registry.yaml`
- Base prompts and guardrails: `agents/base/`
- Agent profiles: `agents/profiles/`
- Toolsets: `agents/tools/`
- Workflows: `agents/workflows/`
- Memory storage: `agents/memory/`
- Runner scripts: `scripts/agents/`
- Agent tests and evals: `tests/agents/`
- Firebender config: `firebender.json` and `.firebender/agents/`
- Cursor rules: `.cursor/rules/`
 - Firebender rules: `.firebender/rules/`

## Cursor Rules

Cursor loads agent rules from `.cursor/rules/`. This repo includes role rules and an automatic
workflow rule so Cursor users follow the same flows and constraints as other tools.

## Roles

- Planner: clarifies requirements and produces plans.
- Supervisor: validates plans and readiness before implementation, and reviews after implementation.
- Architect: reviews architecture alignment before implementation.
- Committer: validates commit readiness and message.
- Pusher: prepares a push checklist and command without executing.
- Implementer: applies approved changes.
- Reviewer: independent quality review; no implementation.
- QA: verification and test execution.
- Documentation: updates docs and indexes.
- Product Manager: PRD, research, and post-implementation intent review.
- Sprint Master: sprint planning and work tracking.

## Workflows

See `docs/agents/workFlows.md` for the workflow guide.
Workflow definitions live in `agents/workflows/`.
