## DAG Scheduler

The DAG scheduler coordinates workflow steps based on dependencies defined in
`agents/workflows/*.yaml`. It ensures steps run only after dependencies are
complete and keeps validation steps aligned with implementation.

## What DAG Means

DAG stands for Directed Acyclic Graph: a set of nodes connected by one-way edges
with no cycles. This makes it ideal for expressing dependency order.

## Where It Lives

- Scheduler logic: `scripts/agents/run-workflow.sh`
- Default runner: `scripts/agents/runner.sh` (used when no external runner is supplied)

## How It Works

- Builds a dependency graph from `dependsOn` in workflow YAML.
- Marks a step runnable only when all dependencies are done.
- Treats review, QA, product review, and supervisor review as validation steps.
- If a validation step fails, resets downstream steps to pending starting from the implementer step.

## How We Use It

- Use workflows in `agents/workflows/` to define the DAG for a run.
- Run a flow via the wrapper scripts in `scripts/agents/`, or call `scripts/agents/run-workflow.sh`
  directly with a workflow id.
- Let the runner advance steps based on `dependsOn` rather than manual sequencing.
- When validation fails, fix issues in the implementer step and re-run downstream steps.

## QA Integration

- QA steps run the configured command list in the runner.
- Use `AGENT_QA_COMMANDS` to override the default sequence. By default the runner calls
  `./scripts/qa.sh`.
