# Workflow Rules

> **For AI Agents:** Work planning, execution, review, and documentation standards

## Never Bypass the Flows

- All work follows the workflow defined in `agents/workflows/`.
- When a user selects a role or step, act as that role and complete the step.
- When a user requests end-to-end work, run the full workflow in order.

## Discuss Before Implementation

- Ask clarifying questions when requirements are unclear.
- Propose alternatives when meaningful tradeoffs exist.
- Confirm the chosen approach before coding.

## Plan Before Execution

- Identify scope, affected files, and dependencies.
- Define verification steps up front.
- Ensure the plan aligns with architecture rules.

## Execute With Discipline

- Follow the approved plan and workflow order.
- Keep changes atomic and focused.
- Update documentation when behavior changes.

## Review and QA

- Reviewer does not implement.
- QA validates independently.
- Resolve review or QA findings before moving on.

## Implementation Summary Requirements

Every delivery must include a brief summary that covers:

- Files changed or created.
- What changed and why.
- Tests run and results.
- Risks, tradeoffs, or follow-ups.

## Work Tracking

- The work board is mandatory.
- If missing, create `docs/tasks/` with:
  - `docs/tasks/workToBeDone.md`
  - `docs/tasks/workDone.md`
  - `docs/tasks/workPlans/README.md`
- Use `docs/tasks/workToBeDone.md` as the work board.
- Derive tasks from the plan and work in plan order.
- Commit per task or per logical unit per commit rules.
- Never push automatically; provide the command for a human to run.

## Library Version Policy

- Use stable releases only.
- Avoid alpha, beta, and RC versions unless explicitly approved.
