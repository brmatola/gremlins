# Worktree Workflow Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use gremlins:executing-plans to implement this plan task-by-task.

**Goal:** Implement the worktree workflow automation system - composable skills that automate plan review, implementation, audit, and reach phases.

**Architecture:** 4 new skills + 1 modified skill + registry update. Skills are standalone but can be orchestrated by worktree-workflow.

**Tech Stack:** Markdown skill files following existing gremlins patterns.

**Related:** [../design/overview.md](../design/overview.md)

---

## Implementation Phases

Execute phases in order. Each phase has its own file with detailed tasks.

| Phase | File | Description |
|-------|------|-------------|
| 1 | [phase-1-gate-skills.md](./phase-1-gate-skills.md) | Create plan-readiness-review and implementation-review |
| 2 | [phase-2-reach-opportunities.md](./phase-2-reach-opportunities.md) | Create reach-opportunities skill |
| 3 | [phase-3-autonomous-mode.md](./phase-3-autonomous-mode.md) | Modify executing-plans for autonomous mode |
| 4 | [phase-4-orchestrator.md](./phase-4-orchestrator.md) | Create worktree-workflow orchestrator |
| 5 | [phase-5-update-registry.md](./phase-5-update-registry.md) | Update using-gremlins with new skills |

## Execution Order

```
Phase 1: Gate Skills (2 tasks)
    └── plan-readiness-review
    └── implementation-review
         ↓
Phase 2: Reach (1 task)
    └── reach-opportunities
         ↓
Phase 3: Autonomous Mode (1 task)
    └── modify executing-plans
         ↓
Phase 4: Orchestrator (1 task)
    └── worktree-workflow
         ↓
Phase 5: Registry (1 task)
    └── update using-gremlins
```

## Dependencies

- Phases 1-3 can be done in any order (independent skills)
- Phase 4 depends on Phases 1-3 (orchestrator invokes those skills)
- Phase 5 depends on all others (registers all new skills)

## Expected Commits

After implementation:

1. `feat(skills): add plan-readiness-review gate skill`
2. `feat(skills): add implementation-review gate skill`
3. `feat(skills): add reach-opportunities skill`
4. `feat(skills): add autonomous mode to executing-plans`
5. `feat(skills): add worktree-workflow orchestrator`
6. `docs(skills): add workflow skills to registry`

## Files Created/Modified

```
skills/
├── plan-readiness-review/
│   └── SKILL.md                 # NEW
├── implementation-review/
│   └── SKILL.md                 # NEW
├── reach-opportunities/
│   └── SKILL.md                 # NEW
├── worktree-workflow/
│   └── SKILL.md                 # NEW
├── executing-plans/
│   └── SKILL.md                 # MODIFIED
└── using-gremlins/
    └── SKILL.md                 # MODIFIED
```

## Verification

After all phases complete, verify success criteria from design:

```bash
# All new skills exist
ls skills/{plan-readiness-review,implementation-review,reach-opportunities,worktree-workflow}/SKILL.md

# Autonomous mode in executing-plans
grep "Autonomous" skills/executing-plans/SKILL.md

# All skills registered
grep "worktree-workflow" skills/using-gremlins/SKILL.md
```

## Notes

- Each skill is tested standalone before moving to next phase
- Orchestrator is created last since it depends on all sub-skills
- Registry update is last to ensure all skills exist first
