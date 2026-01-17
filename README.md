# Gremlins

Disciplined engineering workflows for AI-assisted development. Helpful little creatures that fix things when you invoke them properly.

## What is Gremlins?

Gremlins is a Claude Code plugin that provides skills (reusable workflows) and agents (specialized subagents) for common software engineering tasks:

- **Brainstorming** - Turn ideas into fully-formed designs
- **Planning** - Create detailed implementation plans
- **Executing** - Work through plans systematically
- **Debugging** - Find root causes before fixing
- **TDD** - Test-driven development workflow
- **Code Review** - Request and receive reviews effectively
- **Git Worktrees** - Isolated workspaces for feature work
- **Research** - Ground plans in codebase and internet research
- **Context Maintenance** - Keep CLAUDE.md files in sync with code

## Installation

```bash
claude plugins add github:brmatola/gremlins
```

## Plan Structure

Gremlins uses a folder-based plan organization:

```
plans/
├── active/           # Work in progress
│   └── {plan-name}/
│       ├── design/         # Problem analysis, approach, decisions
│       └── implementation/ # Step-by-step execution plans
├── complete/         # Finished work
└── archive/          # Abandoned or obsolete plans
```

Use `gremlins:plan-complete` and `gremlins:plan-archive` to manage plan lifecycle.

## Available Skills

### Planning & Design

| Skill | When to Use |
|-------|-------------|
| `gremlins:brainstorming` | New features, designs, exploring ideas |
| `gremlins:writing-plans` | Creating implementation plans from specs |
| `gremlins:executing-plans` | Working through an implementation plan |
| `gremlins:plan-complete` | Moving a finished plan to complete/ |
| `gremlins:plan-archive` | Archiving abandoned or obsolete plans |

### Quality & Discipline

| Skill | When to Use |
|-------|-------------|
| `gremlins:systematic-debugging` | Any bug, error, or unexpected behavior |
| `gremlins:test-driven-development` | Writing new functionality |
| `gremlins:verification-before-completion` | Before claiming work is done |

### Code Review

| Skill | When to Use |
|-------|-------------|
| `gremlins:requesting-code-review` | Before creating PRs |
| `gremlins:receiving-code-review` | After getting review feedback |

### Research

| Skill | When to Use |
|-------|-------------|
| `gremlins:investigating-a-codebase` | Understanding existing code before design |
| `gremlins:researching-on-the-internet` | Finding current API docs, library patterns |

### Project Context

| Skill | When to Use |
|-------|-------------|
| `gremlins:maintaining-project-context` | After completing development phases |
| `gremlins:writing-claude-md-files` | Creating or updating CLAUDE.md files |

### Execution

| Skill | When to Use |
|-------|-------------|
| `gremlins:using-git-worktrees` | Isolating feature work |
| `gremlins:subagent-driven-development` | Executing plans with subagents |
| `gremlins:dispatching-parallel-agents` | Independent parallel tasks |
| `gremlins:finishing-a-development-branch` | Completing branch work (PR/merge) |

### Meta

| Skill | When to Use |
|-------|-------------|
| `gremlins:writing-skills` | Creating new skills |

## Available Agents

### General Purpose (Tiered by Complexity)

| Agent | Model | When to Use |
|-------|-------|-------------|
| `haiku-general-purpose` | haiku | Fast, cheap tasks (research, summarization) |
| `sonnet-general-purpose` | sonnet | Balanced tasks (analysis, implementation) |
| `opus-general-purpose` | opus | Complex reasoning, architectural decisions |

### Research

| Agent | Model | When to Use |
|-------|-------|-------------|
| `codebase-investigator` | haiku | Understanding existing code, verifying assumptions |
| `internet-researcher` | haiku | Finding current docs, library patterns, best practices |

### Execution

| Agent | Model | When to Use |
|-------|-------|-------------|
| `task-implementor` | sonnet | Implementing individual tasks from plans |
| `task-bug-fixer` | sonnet | Fixing issues identified by code review |
| `code-reviewer` | inherit | Reviewing completed work against plans |

### Context Maintenance

| Agent | Model | When to Use |
|-------|-------|-------------|
| `project-claude-librarian` | opus | Updating CLAUDE.md files after development phases |

## Philosophy

These skills encode disciplined engineering practices:

1. **Understand before acting** - Investigate root causes, don't guess
2. **Test first** - Write the test, watch it fail, then implement
3. **Verify before claiming** - Run the command, see the output, then claim success
4. **Review early and often** - Catch issues before they compound
5. **Ground in reality** - Research codebase and internet before designing

The skills are designed to resist rationalization - they explicitly counter common excuses for skipping important steps.

## Inspiration

Gremlins is inspired by and adapts content from:

- [Obra Superpowers](https://github.com/obra/superpowers) by Jesse Vincent
- [ed3d-plugins](https://github.com/ed3d/ed3d-plugins) by Ed DeGagne

Many thanks for the excellent foundations.

## License

MIT License - see [LICENSE](LICENSE) for details.
