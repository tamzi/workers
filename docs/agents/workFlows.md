# Workflow Guide

This guide summarizes the available workflows and when to use them. Workflow definitions live in
`agents/workflows/` and are the source of truth.

## Delivery Flow

Use for code changes and feature delivery.

Sequence:
```mermaid
flowchart TD
  plan[Plan] --> supervise[Supervise]
  plan --> architectureReview[Architecture review]
  supervise --> implement[Implement]
  architectureReview --> implement
  implement --> productReview[Product review]
  implement --> supervisorReview[Supervisor review]
  productReview --> review[Review]
  supervisorReview --> review
  productReview --> qa[QA]
  supervisorReview --> qa
  productReview --> docs[Docs]
  supervisorReview --> docs
  docs --> commit[Commit]
  commit --> push[Push checklist]
```

## Product Flow

Use for research, product requirements, and sprint planning.

Sequence:
```mermaid
flowchart TD
  research[Research] --> requirements[Requirements]
  requirements --> sprintPlan[Sprint plan]
```

## Feature Breakdown Flow

Use to turn a feature idea into requirements, epics, stories, and tasks.

Sequence:
```mermaid
flowchart TD
  requirements[Requirements] --> epics[Epics]
  epics --> stories[Stories]
  stories --> tasks[Tasks]
```

## Agile Delivery Flow

Use for end-to-end delivery from requirements to implementation and review.

Sequence:
```mermaid
flowchart TD
  requirements[Requirements] --> epics[Epics]
  epics --> stories[Stories]
  stories --> tasks[Tasks]
  tasks --> plan[Plan]
  plan --> supervise[Supervise]
  plan --> architectureReview[Architecture review]
  supervise --> implement[Implement]
  architectureReview --> implement
  implement --> productReview[Product review]
  implement --> supervisorReview[Supervisor review]
  productReview --> review[Review]
  supervisorReview --> review
  productReview --> qa[QA]
  supervisorReview --> qa
  productReview --> docs[Docs]
  supervisorReview --> docs
  docs --> commit[Commit]
  commit --> push[Push checklist]
```

## Tech Debt Flow

Use for refactors, stabilization, and cleanup work.

Sequence:
```mermaid
flowchart TD
  plan[Plan] --> supervise[Supervise]
  plan --> architectureReview[Architecture review]
  supervise --> implement[Implement]
  architectureReview --> implement
  implement --> supervisorReview[Supervisor review]
  supervisorReview --> review[Review]
  supervisorReview --> qa[QA]
  supervisorReview --> docs[Docs]
  docs --> commit[Commit]
  commit --> push[Push checklist]
```

## Research Spike Flow

Use for time-boxed exploration with recommendations.

Sequence:
```mermaid
flowchart TD
  framing[Framing] --> research[Research]
  research --> architectureReview[Architecture review]
  architectureReview --> recommendation[Recommendation]
  recommendation --> nextSteps[Next steps]
```

## Related References

- `docs/agents/howToUseAgents.md` for usage guidance in chat or terminal.
- `docs/agents/dagScheduler.md` for DAG scheduling rules.
- `agents/workflows/` for the workflow definitions.
