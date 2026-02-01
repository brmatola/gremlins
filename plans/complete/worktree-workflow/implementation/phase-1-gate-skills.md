# Phase 1: Gate Skills Implementation

> **For Claude:** REQUIRED SUB-SKILL: Use gremlins:executing-plans to implement this plan task-by-task.

**Goal:** Create the two gate skills that review plans before and after implementation.

**Architecture:** Each skill is a standalone SKILL.md file following existing gremlins patterns. Gate skills read context, analyze against criteria, and output structured markdown verdicts.

**Tech Stack:** Markdown skill files, bash commands for git operations, grep/read for codebase analysis.

**Related:** [../design/overview.md](../design/overview.md), [./phase-4-orchestrator.md](./phase-4-orchestrator.md)

---

## Task 1: Create plan-readiness-review Skill

**Files:**
- Create: `skills/plan-readiness-review/SKILL.md`

**Step 1: Create the skill directory**

```bash
mkdir -p skills/plan-readiness-review
```

**Step 2: Create the SKILL.md file**

Create `skills/plan-readiness-review/SKILL.md` with this content:

```markdown
---
name: plan-readiness-review
description: Use when you have a plan and want to verify it's ready for implementation - catches structural gaps, feasibility issues, and scope problems
---

# Plan Readiness Review

## Overview

Pressure test whether a plan is ready for implementation. Catches structural gaps, feasibility issues, and scope problems before committing to build.

**Core principle:** Find problems before implementation, not during.

**Announce at start:** "I'm using the plan-readiness-review skill to evaluate this plan."

**Plan location:** `plans/active/{plan-name}/`

## The Process

### Step 1: Load Plan

1. Read all files from `plans/active/{plan-name}/design/`
2. Read all files from `plans/active/{plan-name}/implementation/` (if exists)
3. Note: Plan must be committed to repo before worktree creation

### Step 2: Evaluate Against Criteria

**Structure:**
- [ ] All required sections present (problem, solution, tasks)?
- [ ] Steps specific enough to execute without interpretation?
- [ ] Success criteria defined?
- [ ] Dependencies between tasks identified?

**Feasibility:**
- [ ] Technical approach sound?
- [ ] Required APIs/libraries exist?
- [ ] No impossible constraints?

**Scope:**
- [ ] Right-sized for one branch?
- [ ] Should it be split into multiple plans?
- [ ] Over-engineered for the problem?
- [ ] Missing obvious requirements?

**Clarity:**
- [ ] Would a fresh agent understand every instruction?
- [ ] Any ambiguous instructions?
- [ ] Missing context that implementer would need?

### Step 3: Cross-Reference Codebase

Check if plan accounts for:
- Existing patterns in the codebase
- Files that will be affected
- Test patterns to follow
- Related code that might need updates

### Step 4: Produce Verdict

Output this format:

```
## Plan Readiness Review: {plan-name}

### Verdict: READY | NEEDS WORK | SPLIT RECOMMENDED

### Strengths
- [What's solid about this plan]

### Issues Found
- **[Category]**: [Issue description]
  - Suggested fix: [How to address]

### Questions to Resolve
- [Anything ambiguous that needs human input]

### Recommendation
[1-2 sentence summary of what to do next]
```

## Verdict Meanings

| Verdict | Meaning | Next Step |
|---------|---------|-----------|
| **READY** | Plan is executable as-is | Proceed to implementation |
| **NEEDS WORK** | Fixable issues found | Address issues, re-review |
| **SPLIT RECOMMENDED** | Too large for one branch | Create multiple plans |

## Red Flags

**Never:**
- Rubber-stamp a plan without thorough review
- Skip codebase cross-reference
- Approve plans with ambiguous instructions

**Always:**
- Check every evaluation criterion
- Verify file paths exist or make sense
- Flag anything a fresh agent might misinterpret

## Integration

**Invoked by:**
- **gremlins:worktree-workflow** (start phase) - First gate in workflow
- Standalone when reviewing any plan

**Pairs with:**
- **gremlins:writing-plans** - Reviews output of that skill
- **gremlins:executing-plans** - Feeds into that skill when READY
```

**Step 3: Verify the file was created correctly**

```bash
cat skills/plan-readiness-review/SKILL.md | head -20
```

Expected: See the frontmatter and beginning of the skill.

**Step 4: Commit**

```bash
git add skills/plan-readiness-review/SKILL.md
git commit -m "feat(skills): add plan-readiness-review gate skill

Adds pre-implementation review skill that evaluates plans for:
- Structural completeness
- Technical feasibility
- Appropriate scope
- Clarity for implementers

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
```

---

## Task 2: Create implementation-review Skill

**Files:**
- Create: `skills/implementation-review/SKILL.md`

**Step 1: Create the skill directory**

```bash
mkdir -p skills/implementation-review
```

**Step 2: Create the SKILL.md file**

Create `skills/implementation-review/SKILL.md` with this content:

```markdown
---
name: implementation-review
description: Use after implementing a plan to verify completeness, correctness, and merge safety - the post-implementation gate
---

# Implementation Review

## Overview

Verify implementation is complete, correct, and safe to merge. This is the merge readiness gate.

**Core principle:** Catch issues before merge, not after.

**Announce at start:** "I'm using the implementation-review skill to audit this implementation."

**Plan location:** `plans/active/{plan-name}/`

## The Process

### Step 1: Load Context

1. Read original plan from `plans/active/{plan-name}/`
2. Get current branch name
3. Find base branch (main/master)

```bash
git branch --show-current
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master
```

### Step 2: Gather Implementation Data

Get all commits since diverging from base:

```bash
git log --oneline $(git merge-base HEAD main)..HEAD
```

Get all changed files:

```bash
git diff --name-only $(git merge-base HEAD main)..HEAD
```

### Step 3: Evaluate Against Criteria

**Correctness:**
- [ ] Implementation matches plan intent?
- [ ] Any drift from plan (features added/removed)?
- [ ] All tasks from plan completed?

**Completeness:**
- [ ] Success criteria from plan met?
- [ ] All expected files exist?
- [ ] Nothing half-done or TODO'd?

**Quality:**
- [ ] Code follows project patterns?
- [ ] No obvious bugs?
- [ ] Error handling present where needed?

**Safety:**
- [ ] Tests passing?
- [ ] No regressions in existing tests?
- [ ] No security issues introduced?
- [ ] No debug code left (console.log, print, etc.)?

### Step 4: Run Checks

Run test suite:
```bash
# Detect and run appropriate test command
npm test || cargo test || pytest || go test ./...
```

Check for debug code:
```bash
git diff $(git merge-base HEAD main)..HEAD | grep -E "(console\.log|print\(|debugger|TODO|FIXME)" || echo "None found"
```

### Step 5: Produce Verdict

Output this format:

```
## Implementation Review: {plan-name}

### Verdict: MERGE READY | NEEDS FIXES | MAJOR ISSUES

### Plan Compliance
- [X] Task 1: [Description] - Implemented correctly
- [X] Task 2: [Description] - Implemented correctly
- [ ] Task 3: [Description] - Partial/Missing [reason]

### Test Results
- Suite: {X}/{Y} passing
- Coverage: {Z}% (if available)

### Quality Checks
- [X] No debug code (console.log, print, etc.)
- [X] Follows project patterns
- [X] Error handling present

### Issues Found
- **[Severity: blocker|major|minor]**: [Description]
  - Location: [file:line]
  - Suggested fix: [How to address]

### Recommendation
[Ready to merge / Fix these N issues first]
```

## Verdict Meanings

| Verdict | Meaning | Next Step |
|---------|---------|-----------|
| **MERGE READY** | Safe to merge | Finish branch (merge/PR) |
| **NEEDS FIXES** | Minor issues to address | Fix, re-review |
| **MAJOR ISSUES** | Significant problems | May need plan revision |

## Issue Severity

| Severity | Meaning |
|----------|---------|
| **blocker** | Cannot merge until fixed (test failure, security issue) |
| **major** | Should fix before merge (missing functionality, bad pattern) |
| **minor** | Nice to fix but not blocking (style, minor improvements) |

## Red Flags

**Never:**
- Approve with failing tests
- Skip debug code check
- Ignore plan drift without noting it

**Always:**
- Run actual test suite
- Compare against original plan
- Check for leftover debug artifacts

## Integration

**Invoked by:**
- **gremlins:worktree-workflow** (audit phase) - Post-implementation gate
- Standalone for any implementation review

**Follows:**
- **gremlins:executing-plans** - Reviews output of implementation

**Leads to:**
- **gremlins:finishing-a-development-branch** - When MERGE READY
- **gremlins:reach-opportunities** - When user opts in after passing

**vs verification-before-completion:**
- Use **implementation-review** as the workflow gate (comprehensive, plan-aware)
- Use **verification-before-completion** for quick ad-hoc checks outside workflow
```

**Step 3: Verify the file was created correctly**

```bash
cat skills/implementation-review/SKILL.md | head -20
```

Expected: See the frontmatter and beginning of the skill.

**Step 4: Commit**

```bash
git add skills/implementation-review/SKILL.md
git commit -m "feat(skills): add implementation-review gate skill

Adds post-implementation review skill that verifies:
- Plan compliance and task completion
- Test suite passing
- Code quality and patterns
- No debug artifacts left behind

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
```

---

## Verification

After completing both tasks:

```bash
ls -la skills/plan-readiness-review/
ls -la skills/implementation-review/
git log --oneline -3
```

Expected:
- Both directories exist with SKILL.md files
- Two new commits for the gate skills
