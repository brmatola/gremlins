# Gremlins

Disciplined engineering workflows for AI-assisted development. Helpful little creatures that fix things when you invoke them properly.

## What is Gremlins?

Gremlins is a Claude Code plugin that provides skills (reusable workflows) for common software engineering tasks:

- **Brainstorming** - Turn ideas into fully-formed designs
- **Planning** - Create detailed implementation plans
- **Executing** - Work through plans systematically
- **Debugging** - Find root causes before fixing
- **TDD** - Test-driven development workflow
- **Code Review** - Request and receive reviews effectively
- **Git Worktrees** - Isolated workspaces for feature work

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

| Skill | When to Use |
|-------|-------------|
| `gremlins:brainstorming` | New features, designs, exploring ideas |
| `gremlins:writing-plans` | Creating implementation plans from specs |
| `gremlins:executing-plans` | Working through an implementation plan |
| `gremlins:plan-complete` | Moving a finished plan to complete/ |
| `gremlins:plan-archive` | Archiving abandoned or obsolete plans |
| `gremlins:systematic-debugging` | Any bug, error, or unexpected behavior |
| `gremlins:test-driven-development` | Writing new functionality |
| `gremlins:verification-before-completion` | Before claiming work is done |
| `gremlins:requesting-code-review` | Before creating PRs |
| `gremlins:receiving-code-review` | After getting review feedback |
| `gremlins:using-git-worktrees` | Isolating feature work |
| `gremlins:subagent-driven-development` | Executing plans with subagents |
| `gremlins:dispatching-parallel-agents` | Independent parallel tasks |
| `gremlins:finishing-a-development-branch` | Completing branch work (PR/merge) |
| `gremlins:writing-skills` | Creating new skills |

## Philosophy

These skills encode disciplined engineering practices:

1. **Understand before acting** - Investigate root causes, don't guess
2. **Test first** - Write the test, watch it fail, then implement
3. **Verify before claiming** - Run the command, see the output, then claim success
4. **Review early and often** - Catch issues before they compound

The skills are designed to resist rationalization - they explicitly counter common excuses for skipping important steps.

## Inspiration

Gremlins is inspired by and adapts content from [Obra Superpowers](https://github.com/obra/superpowers) by Jesse Vincent. Many thanks for the excellent foundation.

## License

MIT License - see [LICENSE](LICENSE) for details.
