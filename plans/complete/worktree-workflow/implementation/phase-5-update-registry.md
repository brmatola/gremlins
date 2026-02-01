# Phase 5: Update Skills Registry

> **For Claude:** REQUIRED SUB-SKILL: Use gremlins:executing-plans to implement this plan task-by-task.

**Goal:** Update the using-gremlins skill to include all new skills in the Available Gremlins table.

**Architecture:** Simple table update to register new skills for discoverability.

**Tech Stack:** Modify existing SKILL.md file.

**Related:** [../design/overview.md](../design/overview.md)

---

## Task 1: Update using-gremlins Skill

**Files:**
- Modify: `skills/using-gremlins/SKILL.md`

**Step 1: Read the current skill**

```bash
cat skills/using-gremlins/SKILL.md
```

Find the "Available Gremlins" table.

**Step 2: Add new skills to the table**

Find the table that looks like:

```markdown
## Available Gremlins

| Skill | When to Use |
|-------|-------------|
| `gremlins:brainstorming` | New features, designs, exploring ideas |
...
```

Add these rows in appropriate positions (alphabetically or by workflow order):

```markdown
| `gremlins:implementation-review` | Post-implementation audit before merge |
| `gremlins:plan-readiness-review` | Pre-implementation plan verification |
| `gremlins:reach-opportunities` | Quick wins after implementation passes |
| `gremlins:worktree-workflow` | Full development loop orchestration |
```

**Step 3: Verify the table is updated**

```bash
grep -A30 "Available Gremlins" skills/using-gremlins/SKILL.md
```

Expected: See all four new skills in the table.

**Step 4: Commit**

```bash
git add skills/using-gremlins/SKILL.md
git commit -m "docs(skills): add workflow skills to registry

Adds to Available Gremlins table:
- plan-readiness-review
- implementation-review
- reach-opportunities
- worktree-workflow

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
```

---

## Final Verification

After all phases complete:

**Check all skills exist:**

```bash
ls skills/*/SKILL.md | sort
```

Expected output should include:
- skills/implementation-review/SKILL.md
- skills/plan-readiness-review/SKILL.md
- skills/reach-opportunities/SKILL.md
- skills/worktree-workflow/SKILL.md

**Check git log:**

```bash
git log --oneline -6
```

Expected: 5-6 commits for this implementation.

**Check using-gremlins has new skills:**

```bash
grep -c "gremlins:" skills/using-gremlins/SKILL.md
```

Expected: Count should have increased by 4.

---

## Success Criteria Checklist

From design/overview.md:

- [ ] `/plan-readiness-review` produces comprehensive pre-implementation analysis
- [ ] `/implementation-review` catches quality/completeness issues before merge
- [ ] `/reach-opportunities` identifies relevant quick wins without scope creep
- [ ] `/worktree-workflow` orchestrates full loop with state persistence
- [ ] `executing-plans` runs full plan without stopping by default
- [ ] Each phase produces clear markdown summary for human decision
- [ ] Can use skills standalone or through orchestrator
- [ ] State persists across Claude sessions in same worktree

Manual verification: Test each skill standalone to confirm it works as designed.
