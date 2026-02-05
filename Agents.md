# AI Agent Rules & Guidelines for Worker

> **Purpose:** Centralized rules and guidelines for AI agents working on the Worker project

---

## ⚠️ CRITICAL: Read the Detailed Rules

**This document is a QUICK REFERENCE ONLY.**

For comprehensive, enforceable rules that you **MUST** follow, see:

📁 **[docs/agentRules/](docs/agentRules/)** - Detailed agent rules directory

**Start here:**

- **[docs/agentRules/README.md](docs/agentRules/README.md)** - Complete index and navigation
- **[docs/agentRules/commitRules.md](docs/agentRules/commitRules.md)** - MANDATORY pre-commit
  checklist
- **[docs/agentRules/documentationRules.md](docs/agentRules/documentationRules.md)** - **CRITICAL:**
  Documentation requirements including **NO CODE SNIPPETS IN MARKDOWN** (Rule 7)

**The detailed rules include:**

- ✅ Specific checklists you MUST follow before every commit
- ✅ Architecture patterns (links to actual code, not duplicated examples)
- ✅ Testing requirements and utilities
- ✅ Common mistakes and how to avoid them
- ✅ Enforcement criteria for all standards
- ⚠️ **Rule 7: NO code snippets in .md files - link to actual code instead (Mermaid diagrams allowed)**

## Agent Configuration

For agent structure and usage, see:

- `docs/agents/overview.md`
- `docs/agents/guidelines.md`
- `agents/registry.yaml`

---

## Overview

This document provides essential context, conventions, and guidelines for AI agents (like Codex, Claude,
GitHub Copilot, etc.) contributing to the Worker repository. Worker is a reusable, repo-agnostic
agentic workflow skeleton for consistent collaboration.

## Project Context

### What is Worker?

Worker provides a structured way to run multi-step delivery flows with named agents, dependency-aware
steps, and clear documentation rules.

## Workflow Diagram (Quick Reference)

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
- Tech debt flow:
  `plan -> supervise -> architectureReview -> implement -> supervisorReview`
  `-> (review + qa + docs) -> commit -> push`
- Research spike flow: `framing -> research -> architectureReview -> recommendation -> nextSteps`

## Repository Structure

- `agents/` - Agent registry, profiles, workflows.
- `.firebender/` - Firebender agent definitions.
- `scripts/agents/` - Runner scripts and wrappers.
- `docs/` - Documentation, including `docs/agents/` and `docs/agentRules/`.
- `tests/agents/` - Placeholder for agent tests and evals.

### Tech Stack

Worker is language-agnostic. The consuming repository defines its own stack and tooling.


## Development Guidelines

Follow the rules in `docs/agentRules/` and keep changes minimal and focused. Use the workflows in
`agents/workflows/` as the source of truth for role sequencing.

## Commit Guidelines

See `docs/agentRules/commitRules.md` for comprehensive commit message format and rules.

## Quality Standards

- Code follows project conventions
- Formatting/linting checks pass
- Tests are written and passing
- Public APIs have documentation

## Documentation Standards

### 1. Code Documentation

- **Public APIs:** Must have KDoc comments
- **Complex logic:** Inline comments explaining why, not what
- **TODOs:** Include issue reference or explanation

### 2. Component Documentation

Each component should document:

- Purpose and use case
- Parameters and their effects
- Any special considerations
- Example usage in KDoc (if complex)

### 3. Markdown Documentation

- Use camelCase for markdown files (e.g., `agentRules.md`)
- Include table of contents for long documents
- Use code blocks with language specification for allowed blocks (commands/config)
- Keep line length reasonable (80-120 chars)

## Related Documentation

⚠️ **IMPORTANT:** This document provides a high-level overview. For detailed, comprehensive rules
that **MUST** be followed, see the `docs/agentRules/` directory:

### Essential Reading (READ THESE FIRST!)

- **[README.md](docs/agentRules/README.md)** - Index and quick reference for all agent rules
- **[workflowRules.md](docs/agentRules/workflowRules.md)** - **CRITICAL:** Work planning,
  self-review, implementation summaries, library versions, and documentation preferences
- **[commitRules.md](docs/agentRules/commitRules.md)** - **CRITICAL:** Git commit message
  guidelines, pre-commit checklist, and atomic commit rules
- **[documentationRules.md](docs/agentRules/documentationRules.md)** - **CRITICAL:** Documentation
  location, size limits, and naming conventions

### Architecture & Design

- **[projectOverview.md](docs/agentRules/projectOverview.md)** - Project overview and constraints
- **[architectureRules.md](docs/agentRules/architectureRules.md)** - Clean Architecture layers,
  module dependencies, and data flow patterns

### Development Standards

- **[codingStandards.md](docs/agentRules/codingStandards.md)** - Code style guide, naming
  conventions, and documentation requirements
- **[testingRules.md](docs/agentRules/testingRules.md)** - Testing frameworks, patterns, coverage
  requirements (70%+), and test utilities
- **[featureDevelopmentRules.md](docs/agentRules/featureDevelopmentRules.md)** - Feature structure
  and state management guidance

### Why These Rules Matter

These detailed rules provide:

1. **Specific enforcement criteria** - Clear do's and don'ts with examples
2. **Pre-commit checklists** - Mandatory steps before creating any commit
3. **Architecture patterns** - Proven patterns for maintainable systems
4. **Testing strategies** - Comprehensive testing approaches with code examples
5. **Common mistakes** - Anti-patterns to avoid with corrections

**Before making any commit, you MUST:**

- Review the relevant sections in `docs/agentRules/`
- Follow the pre-commit checklist in `commitRules.md`
- Verify documentation compliance per `documentationRules.md`
- Ensure code quality per `codingStandards.md`
- Check test coverage per `testingRules.md`

## Quick Reference Checklist

Before completing any task, verify:

### Work Planning & Review (see workflowRules.md)

- [ ] Discussion before implementation (for questions/suggestions)
- [ ] Work planned before execution
- [ ] Self-review checklist completed
- [ ] Implementation summary provided
- [ ] Only stable library versions (no alpha/beta)
- [ ] Inline documentation preferred over README code snippets

### Code Quality

- [ ] Code follows project conventions
- [ ] Formatting/linting checks pass
- [ ] Tests are written and passing
- [ ] Public APIs have documentation

### Commit Standards
- [ ] Commit message follows conventional format
- [ ] No TODO comments without explanation or issue reference

## Getting Help

When uncertain about:

- **Architecture decisions:** Check `docs/agentRules/architectureRules.md`
- **Code style:** Check `docs/agentRules/codingStandards.md`
- **Testing:** Check `docs/agentRules/testingRules.md`

## Project Philosophy

1. **Reusability First** - Components should be flexible and reusable
2. **Consistency** - Follow established patterns and conventions
3. **Quality** - Never compromise on code quality or testing
4. **Documentation** - Well-documented code is maintainable code
5. **Simplicity** - Prefer simple, clear solutions over clever ones
6. **Performance** - Write efficient code
7. **Accessibility** - Build inclusive user interfaces

## Notes for AI Agents

- Use workflows in `agents/workflows/` as the source of truth for sequencing.
- Keep docs indexed and follow the documentation rules in `docs/agentRules/`.
- When in doubt, **look at existing repo patterns** before introducing new ones.

---

**Repository:** Worker
