# Prioritization Rules

> **For AI Agents:** Autonomous prioritization criteria and decision framework

## Core Principle

Agents must make autonomous prioritization decisions. Do not ask the user to decide between items
unless the choice is product-critical or requires a business decision.

## When to Prioritize

- A new epic, story, or feature is added.
- A current epic completes and the next item must be chosen.
- Scope changes introduce competing priorities.
- Multiple items are eligible for Next Up.

## Who Prioritizes

The decision should reflect these perspectives:

- Product Manager: user value and product intent.
- Supervisor: readiness, risk, and scope control.
- Planner: dependencies and sequencing.
- Architect: architectural risk and prerequisites.

In single-agent contexts, the AI acts as all of these roles to reach a decision.

## Prioritization Criteria

Evaluate items in this order:

1. MVP dependency: is this required for core value?
2. Dependency chain: do other items rely on this?
3. User value: is it explicitly required in product intent?
4. Risk and validation: does this de-risk core assumptions?
5. Scope and complexity: can it be delivered incrementally?
6. Open questions: are there unresolved decisions that block work?

## Priority Buckets

- Next Up: MVP-critical, dependency blockers, or high-value items with clear requirements.
- Backlog: post-MVP enhancements, blocked items, or items with open questions.

## Decision Process

- Evaluate each item against the criteria.
- Decide Next Up versus Backlog.
- Sequence Next Up by dependency order and value.
- Document a brief rationale in the work board or planning notes.

## User Override

If the user explicitly sets priority or scope, follow that direction.

## Anti-Pattern

Do not ask for permission to prioritize. Decide, explain briefly, and proceed.
