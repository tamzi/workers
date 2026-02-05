# Using Agents in Chat

This guide explains how to run the workflows in chat tools when you want the agents to do the work
end to end.

## Flows Are Mandatory

- The main AI responding in chat must follow the workflow in `agents/workflows/`.
- When a user selects a role, the AI must act as that role and complete the step.
- When a user asks for end-to-end delivery, run the full workflow in order.

## How to Request Work

- For planning only: ask the Planner to produce a plan.
- For implementation only: provide an approved plan and ask the Implementer to execute it.
- For end-to-end delivery: ask to run the agile delivery flow from requirements through commit.

## Per-Task Expectations

- Implementer writes the changes.
- Reviewer performs a separate review.
- QA validates tests and quality gates.
- Documentation updates follow after implementation when behavior changes.
- Committer validates commit readiness and message.
- Pusher provides a push checklist and command only.

## Work Board Behavior

- If the repo uses a work board, agents keep it updated automatically.
- Tasks come from the plan and are worked in plan order.
- Agents commit at the end of each task or logical unit per commit rules.

## If Your Tool Cannot Select Agents

Prefix your prompt with the role name, for example “Act as Planner” or “Act as Implementer.”
