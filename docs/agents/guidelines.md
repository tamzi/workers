# Agent Guidelines

## Role Separation

- Implementer and reviewer are separate roles.
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
- Do not include code snippets in markdown.

## Prompt Storage

- Default prompts live in `agents/base/` and are versioned with the repo.
- Tooling may inject or override prompts at runtime for experiments.
- When overrides are used, record the change in the task notes or sprint plan.

## Product and Sprint Ownership

- Product Manager maintains `docs/product/prd.md` and `docs/product/featureList.md`.
- Sprint Master maintains `docs/workToBeDone.md`.

## Workflow Usage

- Use `agents/workflows/deliveryFlow.yaml` for code changes.
- Use `agents/workflows/productFlow.yaml` for product and sprint planning.
- Use `agents/workflows/featureBreakdownFlow.yaml` for breaking down a feature into requirements, epics, stories, and tasks.
- Use `agents/workflows/agileDeliveryFlow.yaml` when a feature request should run through product, sprint, planning, and delivery steps.
- Use `agents/workflows/techDebtFlow.yaml` for refactors and tech debt cleanup.
- Use `agents/workflows/researchSpikeFlow.yaml` for time-boxed research questions.
