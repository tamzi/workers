# Project Overview

> **For AI Agents:** This file provides essential context about the Worker repository.

## What is Worker?

Worker is a reusable, repo-agnostic agentic workflow skeleton. It defines agent roles,
workflow dependencies, and documentation rules so teams can run consistent delivery flows.

## Tech Stack

Worker is language-agnostic. The consuming repository defines its own language, tooling,
build system, and testing stack.

## Architecture

- Role-based agent workflows with explicit dependencies
- Separation of responsibilities across planning, implementation, review, and QA
- Documentation-driven rules and checklists to keep changes consistent

## Repository Structure

- `agents/` - Agent registry, profiles, workflows, and base prompts
- `.firebender/` - Firebender agent definitions
- `scripts/agents/` - Runner scripts and workflow wrappers
- `docs/` - Documentation, including `agentRules/` and `agents/`
- `tests/agents/` - Placeholder for agent tests/evals

## Repository Information

- **Main Branch:** `main`
- **Workflow:** Feature branches → Pull Requests → Main

## Key Principles

1. **Clarity** - Explicit roles and handoffs
2. **Quality** - Review and QA before release
3. **Documentation** - Rules live in `docs/agentRules/`
4. **Consistency** - Workflows are the source of truth
