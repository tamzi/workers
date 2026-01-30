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

- Delivery flow: plan, supervise, architecture review, implement, product/supervisor review, review, QA, docs, commit, push.
- Product flow: research, PRD updates, sprint planning.
- Feature breakdown flow: product requirements, epics, stories, tasks.
- Agile delivery flow: requirements to delivery with epics, stories, tasks, and implementation.
- Tech debt flow: refactor and reduce technical debt with architecture review.
- Research spike flow: time-boxed research with recommendation and next steps.

See `agents/workflows/` for definitions.

## Workflow Diagrams

Grouped steps indicate dependency joins (parallel-ready), while correctness-first runs them
sequentially.

- Delivery flow:
  `plan -> supervise -> architectureReview -> implement -> (productReview + supervisorReview)`
  `-> (review + qa + docs) -> commit -> push`
- Product flow: `research -> requirements -> sprintPlan`
- Feature breakdown flow: `requirements -> epics -> stories -> tasks`
- Agile delivery flow:
  `requirements -> epics -> stories -> tasks -> plan -> supervise -> architectureReview -> implement`
  `-> (productReview + supervisorReview) -> (review + qa + docs) -> commit -> push`
- Tech debt flow: `plan -> supervise -> architectureReview -> implement -> supervisorReview -> (review + qa + docs) -> commit -> push`
- Research spike flow: `framing -> research -> architectureReview -> recommendation -> nextSteps`
