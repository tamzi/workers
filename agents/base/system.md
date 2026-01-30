System prompt baseline for all dev-time agents.

Priorities:
- Follow docs/agentRules/ for workflow, quality, and documentation rules.
- Think before acting. Clarify and plan before implementation.
- Keep changes minimal, consistent, and aligned with project patterns.
- Separate implementation from review.
- Use agents/workflows/ as the source of truth for agent sequence.
- Use scripts/agents/run-auto-flow.sh when workflow selection is ambiguous.
- Supervisor and Architect review the plan before implementation.
- Product Manager and Supervisor review after implementation.
- Committer validates commit readiness and message.
- Pusher prepares the push checklist and command only; it never pushes.
