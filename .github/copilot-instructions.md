# GitHub Copilot Repository Instructions

Use these instructions when assisting in this repository. They mirror the repo workflows and agent
rules so Copilot follows the same constraints as other tools.

**Source of Truth**
- `docs/agentRules/` defines planning, testing, documentation, and commit rules.
- `docs/agents/howToUseAgents.md` is the primary workflow guide.
- `docs/agents/workFlows.md` lists workflow sequences.
- `agents/workflows/` contains workflow definitions.

**Workflow Enforcement**
- Do not bypass the workflow steps.
- If the user asks to implement or “use agents,” run the agile delivery flow unless they request a
  different flow.
- When the user selects a role, act as that role and complete the requested step.

**Auto-Routing (Make It Automatic)**
- If the user says implement, build, add, deliver, or fix, run the agile delivery flow.
- If the user says research or requirements, run the product flow.
- If the user says break down, epics, stories, or tasks, run the feature breakdown flow.
- If the user says refactor, tech debt, or cleanup, run the tech debt flow.
- If the user says spike or time-boxed exploration, run the research spike flow.
- If the request is ambiguous, default to agile delivery and ask clarifying questions only when
  required to proceed.

**Work Board (If Present)**
**Work Board (Mandatory)**
- The work board must always exist.
- If missing, create `docs/tasks/` with:
  - `docs/tasks/workToBeDone.md`
  - `docs/tasks/workDone.md`
  - `docs/tasks/workPlans/README.md`
- Use `docs/tasks/workToBeDone.md` as the work board.
- Derive tasks from the plan and work in board order.
- Update the board as tasks complete.

**Per-Task Expectations**
- Implement changes, then review and validate.
- Run relevant checks and tests before completion.
- Update documentation if behavior changes.
- Commit with a compliant message and do not push.

**Documentation Rules**
- Keep docs concise and in `docs/` (except module READMEs).
- Do not include code snippets in markdown, except Mermaid diagrams.
- Update `docs/README.md` when adding new docs.

**Testing and QA**
- Add or update tests for behavior changes.
- Run the repo’s QA and test commands as defined by the project.

**Commit Rules**
- Follow `docs/agentRules/commitRules.md`.
- One logical change per commit.
- One documentation file per commit.
- Never run `git push`; provide the command for a human to run.

**Terminal Workflows**
- Use `scripts/agents/` and follow `docs/agents/usingAgentsInTerminal.md` if script-driven flow is
  needed.
