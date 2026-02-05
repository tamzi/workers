# Using Agents in Terminal

This guide explains how to run the workflow scripts from the terminal and complete each step file
in order.

## When to Use Terminal Workflows

- You want a local run folder with one file per step.
- You prefer editing step files in your editor instead of chat prompts.
- You need a repeatable, script-driven workflow for a team.

## How It Works

- A runner script creates a run folder under `build/agentRuns/`.
- Each step is written to a numbered markdown file.
- You complete each file in order, using the previous step’s output as input.

## Choose a Workflow

Pick the workflow that matches your request:

- Delivery flow for code changes and feature delivery.
- Product flow for research, requirements, and sprint planning.
- Feature breakdown flow for requirements, epics, stories, and tasks.
- Agile delivery flow for end-to-end delivery from requirements to implementation.
- Tech debt flow for refactors, stabilization, and cleanup.
- Research spike flow for time-boxed exploration.

## Run the Workflow Script

From the repo root, run the matching script under `scripts/agents/` and pass a short request.

## Complete the Step Files

- Open the generated run folder under `build/agentRuns/`.
- Fill each step file in order.
- Mark each step complete by setting `Status: done` and checking the checklist items.
- Use the output from the previous step as input for the next.

## Related References

- `docs/agents/howToUseAgents.md` for overall workflow guidance.
- `docs/agents/workFlows.md` for workflow diagrams.
- `scripts/agents/` for all runner scripts.
