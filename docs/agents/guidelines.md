# Agent Guidelines

## Role Separation

- Implementer and Reviewer are separate roles.
- Reviewer does not implement or edit files.
- QA validates independently from implementation.
- Supervisor reviews plans and does not implement.
- Architect reviews architecture alignment and does not implement.
- Product Manager reviews delivered work against intent and does not implement.
- Committer validates commit readiness and does not push.
- Pusher prepares push instructions and does not push.

## Documentation Rules

- All documentation lives in `docs/` except module READMEs.
- Update `docs/README.md` when adding new docs.
- Do not include code snippets in markdown, except Mermaid diagrams.

## Product and Sprint Ownership

- Product Manager maintains product-facing docs when present (for example under `docs/product/`).
- Sprint Master maintains the work board when present (for example under `docs/tasks/`).

## Work Execution Expectations

- Agents create the plan first, then tasks come from it.
- Work through tasks in plan order.
- Commit at the end of each task or logical unit per commit rules.
- Update the work board automatically when tasks are completed.
- If the work board is missing, create `docs/tasks/` with the required templates.
- Never push; provide the command for a human to run.

## Workflow Usage

- Use `agents/workflows/deliveryFlow.yaml` for code changes.
- Use `agents/workflows/productFlow.yaml` for product and sprint planning.
- Use `agents/workflows/featureBreakdownFlow.yaml` for breaking down a feature.
- Use `agents/workflows/agileDeliveryFlow.yaml` when a feature request should run through product,
  sprint, planning, and delivery steps.
- Use `agents/workflows/techDebtFlow.yaml` for refactors and tech debt cleanup.
- Use `agents/workflows/researchSpikeFlow.yaml` for time-boxed research questions.
