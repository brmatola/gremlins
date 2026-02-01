# Phase 3: Autonomous Mode for executing-plans

> **For Claude:** REQUIRED SUB-SKILL: Use gremlins:executing-plans to implement this plan task-by-task.

**Goal:** Modify the existing executing-plans skill to add autonomous mode as the new default.

**Architecture:** Add mode flag to skill, change default behavior from batched checkpoints to continuous execution until completion or blocker.

**Tech Stack:** Modify existing SKILL.md file.

**Related:** [../design/overview.md](../design/overview.md), [./phase-4-orchestrator.md](./phase-4-orchestrator.md)

---

## Task 1: Modify executing-plans Skill

**Files:**
- Modify: `skills/executing-plans/SKILL.md`

**Step 1: Read the current skill**

```bash
cat skills/executing-plans/SKILL.md
```

Understand current structure before modifying.

**Step 2: Update the skill description in frontmatter**

Change the frontmatter description to mention modes:

```markdown
---
name: executing-plans
description: Use when you have a written implementation plan to execute - runs autonomously by default, or in batched mode with checkpoints
---
```

**Step 3: Update the Overview section**

Replace the Overview section with:

```markdown
## Overview

Load plan, review critically, execute tasks until complete or blocked.

**Core principle:** Autonomous execution with stops only for blockers.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Plan location:** `plans/active/{plan-name}/implementation/`

## Execution Modes

| Mode | Invocation | Behavior |
|------|------------|----------|
| **Autonomous** | `/executing-plans` (default) | Run full plan, stop only for blockers |
| **Batched** | `/executing-plans --batched` | Execute 3 tasks → checkpoint → repeat |

**Invocation syntax:**
- Default: `/executing-plans {plan-name}` - runs autonomous
- Batched: `/executing-plans {plan-name} --batched` - runs with checkpoints
- The `--batched` flag can appear anywhere in args

**When to use batched mode:**
- Large plans where you want incremental review
- Plans with uncertain requirements
- When explicitly requested by user

**Autonomous is default** because:
- Reduces back-and-forth for well-defined plans
- Faster end-to-end execution
- Blockers still trigger stops

**Note:** This is a default behavior change. Previous behavior was batched. Users expecting checkpoints should add `--batched`.
```

**Step 4: Update The Process section**

Replace Steps 2-4 with mode-aware execution:

```markdown
### Step 2: Execute Tasks

**Autonomous Mode (default):**

For each task in sequence:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed
5. **Continue to next task** (don't stop)

Stop ONLY when:
- All tasks complete
- Hit a blocker (test failure, missing dependency, unclear instruction)
- Verification fails repeatedly

**Batched Mode (`batched: true`):**

Execute in batches of 3 tasks:
1. Complete 3 tasks following steps above
2. Stop and report progress
3. Wait for feedback
4. Continue with next batch

### Step 3: Handle Blockers

When hitting a blocker in either mode:
1. Stop immediately
2. Report what blocked you
3. Report what was completed so far
4. Wait for guidance

**Don't guess past blockers** - ask for help.

### Step 4: Report Completion

**Autonomous mode completion report:**

```
## Execution Complete: {plan-name}

### Tasks Completed: {X}/{Y}

### Summary
| Task | Status | Commit |
|------|--------|--------|
| Task 1 description | ✓ Done | abc123 |
| Task 2 description | ✓ Done | def456 |

### Test Results
- Final suite: {X}/{Y} passing

### Blockers Encountered
- [None / List any and how resolved]

### Ready for: implementation-review
```

**Batched mode report:** Same as current (show batch, wait for feedback).
```

**Step 5: Update Step 5 (Complete Development)**

Keep existing Step 5 as-is - it already invokes finishing-a-development-branch.

**Step 6: Update the Remember section**

Add mode awareness:

```markdown
## Remember

- Review plan critically first
- **Autonomous is default** - run to completion unless blocked
- **Batched mode** - stop every 3 tasks for checkpoint
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
```

**Step 7: Verify changes**

```bash
cat skills/executing-plans/SKILL.md
```

Verify:
- Frontmatter updated
- Modes table present
- Autonomous behavior documented
- Completion report format included

**Step 8: Commit**

```bash
git add skills/executing-plans/SKILL.md
git commit -m "feat(skills): add autonomous mode to executing-plans

Changes executing-plans to run autonomously by default:
- Continuous execution until complete or blocked
- Batched mode still available with 'batched: true' flag
- Adds completion report format for autonomous mode

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
```

---

## Verification

After completing:

```bash
grep -A5 "Execution Modes" skills/executing-plans/SKILL.md
git log --oneline -1
```

Expected:
- Modes table visible in output
- Commit for autonomous mode addition
