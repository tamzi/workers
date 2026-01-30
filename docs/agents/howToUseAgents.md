# How to Use Agents

This guide explains when to use each agent, which workflow to follow, and how to run flows in chat or terminal.

## When to Use Each Agent

- Planner: clarify requirements and produce a plan before implementation.
- Supervisor: validate the plan scope, risks, and readiness before implementation, and review after implementation.
- Architect: review architecture alignment before implementation.
- Committer: validate commit readiness and propose a compliant commit message.
- Pusher: prepare a push checklist and command without executing.
- Implementer: apply the approved plan in code.
- Reviewer: review changes without editing files.
- QA: validate behavior, tests, and quality gates.
- Documentation: update docs and indexes.
- Product Manager: define product requirements and epics, and review delivered work against intent.
- Sprint Master: turn requirements into stories and tasks.

## Which Workflow to Use

- Delivery flow: use for code changes and feature delivery.
- Product flow: use for research, PRD updates, and sprint planning.
- Feature breakdown flow: use to turn a feature idea into requirements, epics, stories, and tasks.
- Agile delivery flow: use when a feature request should be broken down before implementation.
- Tech debt flow: use for refactors, stabilization, and cleanup work.
- Research spike flow: use for time-boxed exploration and recommendations.

## Keyword Triggers (Chat)

Use short prompts without role labels. The workflow determines the agent sequence.
In terminal, `scripts/agents/run-auto-flow.sh` enforces a simple intent score and defaults to agile delivery when the request is ambiguous.

- Plan: triggers delivery flow starting at Planner.
- Research or requirements: triggers product flow starting at Product Manager.
- Break down or epics or stories or tasks: triggers feature breakdown flow.
- Implement or code or build: triggers agile delivery flow (Product Manager → Sprint Master → Planner → Supervisor → Architect → Implementer → Product Manager → Supervisor → Review → QA → Docs → Committer → Pusher).
- Undocumented or does not exist or new feature: triggers product flow first to establish requirements.
- Refactor or tech debt or cleanup: triggers tech debt flow.
- Spike or time-boxed exploration: triggers research spike flow.

## How to Use in Chat (Cursor or Firebender)

1. Pick the workflow.
2. Run each step in order by selecting the agent for that step.
3. Paste the output from one step into the next step as input.

If your tool does not allow agent selection, state the role in your prompt, for example:
- “Act as Product Manager: write product requirements for …”
- “Act as Sprint Master: derive stories from these epics …”

Example (delivery flow in chat, keyword triggers):
1. “Plan the changes needed to add a validation warning during data import.”
2. “Review the plan for scope and readiness.”
3. “Review the plan for architectural alignment.”
4. “Implement the approved plan.”
5. “Review the implementation against product intent.”
6. “Review the implementation for readiness.”
7. “Review the changes for correctness and risks.”
8. “Validate with tests and checks.”
9. “Update docs and indexes if behavior changed.”
10. “Confirm commit readiness and propose a compliant commit message.”
11. “Provide push checklist and command.”

Example (product flow in chat, keyword triggers):
1. “Research and summarize constraints for validation warnings.”
2. “Update product requirements based on the research.”
3. “Turn the requirements into a sprint plan.”

Example (feature breakdown in chat, keyword triggers):
1. “Write product requirements for a validation warning during data import.”
2. “List epics with a short goal for each.”
3. “Turn these epics into user stories with acceptance criteria.”
4. “Break these stories into implementation tasks.”

Example (agile delivery in chat, keyword triggers):
1. “Implement a validation warning during data import.”
2. “Provide requirements, epics, stories, and tasks before any code changes.”
3. “Plan the implementation steps.”
4. “Review the plan for scope and readiness.”
5. “Review the plan for architectural alignment.”
6. “Apply the approved plan.”
7. “Review the implementation against product intent.”
8. “Review the implementation for readiness.”
9. “Review, validate, and update docs if needed.”
10. “Confirm commit readiness and propose a compliant commit message.”
11. “Provide push checklist and command.”

## How to Use in Terminal

Use the runner scripts to scaffold a run folder and step files.

- Delivery: `scripts/agents/run-delivery-flow.sh --request "<feature idea>"`
- Product: `scripts/agents/run-product-flow.sh --request "<topic>"`
- Feature breakdown: `scripts/agents/run-feature-breakdown-flow.sh --request "<feature idea>"`
- Agile delivery: `scripts/agents/run-agile-delivery-flow.sh --request "<feature idea>"`
- Tech debt: `scripts/agents/run-tech-debt-flow.sh --request "<refactor idea>"`
- Research spike: `scripts/agents/run-research-spike-flow.sh --request "<question>"`
- Auto (keyword routing): `scripts/agents/run-auto-flow.sh --request "<feature idea>"`

The script creates a run folder under `build/agentRuns/` with one file per step.
Run artifacts and QA logs stay under `build/` and should not be committed.

Example (delivery flow in terminal):
1. Run `scripts/agents/run-delivery-flow.sh --request "Add validation warning during data import"`.
2. Open the generated `01_plan.md` and fill it in.
3. Use that output to complete each step file in order.

Example (product flow in terminal):
1. Run `scripts/agents/run-product-flow.sh --request "Define requirements for validation warnings"`.
2. Open each generated step file in order and fill it in.

Example (feature breakdown in terminal):
1. Run `scripts/agents/run-feature-breakdown-flow.sh --request "Warn about invalid records during import"`.
2. Open the generated `01_requirements.md` and fill it in.
3. Use that output to complete `02_epics.md`, then `03_stories.md`, then `04_tasks.md`.

Example (agile delivery in terminal):
1. Run `scripts/agents/run-agile-delivery-flow.sh --request "Implement validation warnings during import"`.
2. Fill in `01_requirements.md`, then continue each step file in order, including the commit and push steps.

Example (auto routing in terminal):
1. Run `scripts/agents/run-auto-flow.sh --request "Implement validation warnings during import"`.
2. The command selects the workflow based on keywords and creates the step files.

Example (tech debt in terminal):
1. Run `scripts/agents/run-tech-debt-flow.sh --request "Refactor import pipeline for clarity"`.
2. Fill in `01_plan.md`, then continue each step file in order.

Example (research spike in terminal):
1. Run `scripts/agents/run-research-spike-flow.sh --request "Spike: best approach for structured data parsing"`.
2. Fill in each step file in order, ending with recommended next steps.

## DAG-aware Runner (Correctness-First)

The workflow runner reads `dependsOn` from workflow YAML and schedules steps only when their
dependencies are done. It runs one step at a time for correctness.

See `docs/agents/dagScheduler.md` for the full behavior and constraints.

- **Status gating:** A step is complete only when `Status: done` and all checklist items are checked.
- **Auto-retry:** If a step is not done, the runner marks it `needs_fix` and re-runs it after fixes.
- **Validation loops:** If review/QA steps find issues, the runner returns to the implementer step
  and replays downstream steps until the issues are resolved.
- **QA commands:** QA runs the configured command list every time. Override with `AGENT_QA_COMMANDS`
  (semicolon-separated) if needed.
- **Source of truth:** See `scripts/agents/run-workflow.sh`.
- **Default runner:** If `scripts/agents/runner.sh` exists, it is used for end-to-end validation
  when no runner is supplied.

## Where Things Live

- Registry: `agents/registry.yaml`
- Workflows: `agents/workflows/`
- Profiles: `agents/profiles/`
- Firebender agents: `.firebender/agents/`
- Runner scripts: `scripts/agents/`
- Rules: `docs/agentRules/`

## Skills vs Agent Rules

Agent rules are repo documentation under `docs/agentRules/`. Skills are a Codex feature stored under
`~/.codex/skills/` and are not automatically used by Cursor or Firebender. If you maintain a Codex
skill for this repo, mention its name to activate it.
