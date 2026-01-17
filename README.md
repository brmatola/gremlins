# Gremlins

Disciplined engineering workflows for AI-assisted development. Helpful little creatures that fix things when you invoke them properly.

## How It Works

You write natural language. Gremlins recognizes what you're trying to do and applies the right workflow automatically.

### The Workflow: Plan → Implement → Review

Most work follows this cycle:

1. **Plan** - Clarify what you're building, explore approaches, write it down
2. **Implement** - Work through the plan systematically with tests
3. **Review** - Verify the work before calling it done

You don't need to remember this - just describe what you want and gremlins guides you through the appropriate steps.

### Examples

**Building something new:**
> "I want to add a dark mode toggle to the settings page"

Gremlins asks clarifying questions, proposes design options, creates an implementation plan, then works through it with tests.

**Fixing a bug:**
> "The login form isn't validating emails correctly"

Gremlins investigates before fixing: reproduce → find root cause → write failing test → fix → verify.

**Shipping work:**
> "I think this feature is done"

Gremlins verifies before claiming success: runs tests, checks the diff, reviews against the original plan.

### The Plans Folder

Gremlins tracks work in a `plans/` directory:

```
plans/
├── active/           # Work in progress
│   └── {plan-name}/
│       ├── design/         # Problem analysis, approach, decisions
│       └── implementation/ # Step-by-step execution plans
├── complete/         # Finished work (for reference)
└── archive/          # Abandoned or obsolete plans
```

This gives you a paper trail of what was built and why.

## Installation

```bash
/plugin marketplace add brmatola/gremlins
/plugin install gremlins@gremlins
```

Start a conversation and describe what you want to do.

## Philosophy

These workflows encode disciplined engineering practices:

- **Understand before acting** - Investigate root causes, don't guess
- **Test first** - Write the test, watch it fail, then implement
- **Verify before claiming** - Run the command, see the output, then claim success
- **Ground in reality** - Research the codebase before designing

The workflows resist rationalization - they counter common excuses for skipping important steps.

## Inspiration

Gremlins adapts content from:

- [Obra Superpowers](https://github.com/obra/superpowers) by Jesse Vincent
- [ed3d-plugins](https://github.com/ed3d/ed3d-plugins) by Ed DeGagne

## License

MIT License - see [LICENSE](LICENSE) for details.
