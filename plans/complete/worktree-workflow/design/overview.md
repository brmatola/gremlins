# Worktree Workflow Automation

## Problem

The current worktree-based development loop requires manual prompting at each phase:

1. **Plan review** - Typing vague prompts like "review plan X for gaps"
2. **Implementation** - Repeatedly typing "continue" when agent stops for batch checkpoints
3. **Post-implementation review** - Manual quality/completeness checks
4. **Reach opportunities** - Ad-hoc "what else could we add?" prompts

This workflow is repetitive and the prompts are underspecified, leading to inconsistent results.

## Solution

Create a set of composable skills that automate each phase, plus an orchestrator that chains them together with state tracking.

### Architecture

**New Skills:**

| Skill | Purpose | Standalone Use |
|-------|---------|----------------|
| `plan-readiness-review` | Pre-implementation gate | "Is this plan ready to build?" |
| `implementation-review` | Post-implementation gate | "Is this safe to merge?" |
| `reach-opportunities` | Enhancement finder | "What low-hanging fruit exists?" |
| `worktree-workflow` | Orchestrator | "Run the full development loop" |

**Commands:** start, implement, audit, reach, status, abort

**Modified Skills:**

| Skill | Change |
|-------|--------|
| `executing-plans` | Add autonomous mode (new default) |

**Flow when orchestrated:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     worktree-workflow                           │
├─────────────────────────────────────────────────────────────────┤
│  plan-readiness-review  →  executing-plans  →  implementation-  │
│        (gate)              (autonomous)          review (gate)  │
│                                                       │         │
│                                              ┌────────┴───────┐ │
│                                              ▼                ▼ │
│                                    finishing-a-       reach-    │
│                                    development-       opps      │
│                                    branch          (opt-in)     │
└─────────────────────────────────────────────────────────────────┘
```

Each gate runs autonomously, then presents a **markdown summary** for human decision.

---

## Skill Designs

### 1. `plan-readiness-review`

**Purpose:** Pressure test whether a plan is ready for implementation. Catches structural gaps, feasibility issues, and scope problems before committing to build.

**Evaluation criteria:**

| Category | Checks |
|----------|--------|
| **Structure** | All required sections present? Steps specific enough? Success criteria defined? Dependencies identified? |
| **Feasibility** | Technical approach sound? Required APIs/libraries exist? No impossible constraints? |
| **Scope** | Right-sized for one branch? Should be split? Over-engineered? Missing obvious requirements? |
| **Clarity** | Ambiguous instructions? Missing context? Would a fresh agent understand this? |

**Process:**
1. Load plan from `plans/active/{plan-name}/`
2. Read design docs + implementation plan (if exists)
3. Analyze against evaluation criteria
4. Cross-reference with codebase (does plan account for existing patterns?)
5. Produce findings with interactive summary

**Output format:**

```markdown
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

---

### 2. `implementation-review`

**Purpose:** Verify implementation is complete, correct, and safe to merge. This is the merge readiness gate.

**Evaluation criteria:**

| Category | Checks |
|----------|--------|
| **Correctness** | Does implementation match plan? Any drift? All tasks completed? |
| **Completeness** | Success criteria met? All expected files exist? Nothing half-done? |
| **Quality** | Code follows project patterns? No obvious bugs? Error handling present? |
| **Safety** | Tests passing? No regressions? No security issues? No debug code left? |

**Process:**
1. Load original plan from `plans/active/{plan-name}/`
2. Get all commits on branch since diverging from main
3. Analyze changes against plan requirements
4. Run test suite, capture results
5. Check for common issues (console.logs, TODOs, commented code)
6. Produce findings with interactive summary

**Output format:**

```markdown
## Implementation Review: {plan-name}

### Verdict: MERGE READY | NEEDS FIXES | MAJOR ISSUES

### Plan Compliance
- [X] Task 1: Implemented correctly
- [X] Task 2: Implemented correctly
- [ ] Task 3: Partial - missing error handling

### Test Results
- Suite: {X}/{Y} passing
- Coverage: {Z}% (if available)

### Quality Checks
- [ ] No console.log/debug code
- [X] Follows project patterns
- [X] Error handling present

### Issues Found
- **[Severity]**: [Description]
  - Location: [file:line]
  - Suggested fix: [How to address]

### Recommendation
[Ready to merge / Fix these N issues first]
```

---

### 3. `reach-opportunities`

**Purpose:** Identify low-hanging enhancements aligned with the plan's goals. Opportunistic improvements when implementation went well.

**Key principle:** Quick wins only, not scope creep. If something is too involved, spin it off into a new plan.

**What it looks for:**

| Category | Examples |
|----------|----------|
| **Adjacent improvements** | "We added preferences - should we add reset-to-defaults?" |
| **Obvious gaps** | "Happy path done but this common edge case isn't handled" |
| **Polish** | "Loading states, better error messages, keyboard shortcuts" |
| **Documentation** | "New patterns worth adding to CLAUDE.md?" |
| **Test coverage** | "Edge cases worth covering while context is fresh" |

**Constraints:**
- Must relate to the plan's original goals (no random tangents)
- Complexity tiers: **trivial** (few lines), **small** (single file), **medium** (multiple files but bounded)
- Anything beyond medium → spin off to new plan

**Output format:**

```markdown
## Reach Opportunities: {plan-name}

### Context
[Brief summary of what was built and why these opportunities exist]

### Opportunities Found

#### 1. [Opportunity Name]
- **Complexity:** trivial | small | medium
- **Value:** [Why it's worth doing]
- **Implementation:** [Brief description]

#### 2. [Opportunity Name]
- **Complexity:** trivial | small | medium
- **Value:** [Why it's worth doing]
- **Implementation:** [Brief description]

#### 3. [Too Big - Spin Off]
- **Why it's related:** [Connection to plan goals]
- **Why spin off:** [Too complex for reach, needs own design]
- **Suggested plan name:** `{new-plan-name}`

### Recommendation
[Which to tackle now vs defer]
```

---

### 4. `executing-plans` Modification

**Change:** Add autonomous mode as the new default.

| Mode | Flag | Behavior |
|------|------|----------|
| **Autonomous** | default | Run full plan, stop only for blockers |
| **Batched** | `batched: true` | Execute 3 tasks → checkpoint → repeat |

**Autonomous mode behavior:**

| Situation | Batched | Autonomous |
|-----------|---------|------------|
| Task completed | Continue to next in batch | Continue to next task |
| Batch of 3 done | Stop, report, wait | Keep going |
| All tasks done | Report complete | Report complete |
| Blocker hit | Stop, ask | Stop, ask (same) |
| Test failure | Stop, ask | Stop, ask (same) |

**Autonomous completion report:**

```markdown
## Execution Complete: {plan-name}

### Tasks Completed: {X}/{Y}

### Summary
| Task | Status | Commit |
|------|--------|--------|
| Task 1 | ✓ Done | abc123 |
| Task 2 | ✓ Done | def456 |

### Test Results
- Final suite: {X}/{Y} passing

### Blockers Encountered
- [None / List any and how resolved]

### Ready for: implementation-review
```

---

### 5. `worktree-workflow` Orchestrator

**Purpose:** Chain phases together with state tracking. Guide through the full development loop.

**State file:** `.claude/workflow-state.json`

```json
{
  "plan": "feature-name",
  "phase": "review" | "implement" | "audit" | "reach" | "complete",
  "started": "2025-01-31T...",
  "history": [
    { "phase": "review", "verdict": "READY", "timestamp": "..." },
    { "phase": "implement", "tasks": "12/12", "timestamp": "..." }
  ],
  "reachIterations": 0
}
```

**Note:** State file is automatically added to `.gitignore` - it's session-specific and should not be committed.

**Invocation patterns:**

| Command | Behavior |
|---------|----------|
| `/worktree-workflow` | Auto-detect phase from state, continue where left off |
| `/worktree-workflow start {plan}` | Initialize workflow, run readiness review |
| `/worktree-workflow implement` | Kick off autonomous implementation |
| `/worktree-workflow audit` | Run implementation review |
| `/worktree-workflow reach` | Run reach opportunities |
| `/worktree-workflow status` | Show current state and history |

**Phase transitions:**

```
start → [plan-readiness-review] → markdown summary
                                        ↓
                              User: "looks good" / adjust
                                        ↓
implement → [executing-plans autonomous] → markdown summary
                                        ↓
audit → [implementation-review] → markdown summary
                                        ↓
                    AskUserQuestion: "What next?"
                         ┌──────────────┴──────────────┐
                         ↓                             ↓
                   "Done, finish branch"        "Explore reach opportunities"
                         ↓                             ↓
                   [sync-with-base]             reach → [reach-opportunities]
                         ↓                             ↓
           [finishing-a-development-branch]    pick items → implement
                         ↓                             ↓
                   [plan-complete]             back to audit
```

**Key behaviors:**
- Each phase runs autonomously, then presents markdown summary
- Human decides when to advance to next phase
- After implementation-review passes, user chooses: finish branch OR explore reach (opt-in)
- Reach opportunities loop back to audit after implementation
- Can skip phases (e.g., go straight to audit if implemented manually)
- State persists across sessions (pick up where left off)
- **Before finishing:** Always sync with base branch to ensure merge readiness
- **After finishing:** Invoke plan-complete to move plan from active/ to complete/

---

## Assumptions

- **Plans committed before worktree creation:** The plan exists in `plans/active/{plan-name}/` on main before the worktree is created. This ensures plan visibility in the worktree. Plans are not revised mid-workflow.
- **One workflow per worktree:** Each worktree runs a single workflow at a time.
- **One Claude session per worktree:** State file has no locking. Running multiple Claude sessions in the same worktree may cause conflicts.
- **Conversational summaries:** Phase outputs are markdown rendered in conversation, not stored as artifacts.
- **Feature branches only:** Workflow refuses to run on main/master branch.

---

## Skill Integration

This workflow orchestrates and relates to several existing skills:

| Existing Skill | Relationship |
|----------------|--------------|
| `executing-plans` | **Modified** - gains autonomous mode, invoked during implement phase |
| `verification-before-completion` | **Coexists** - use for ad-hoc checks outside workflow; implementation-review is the workflow gate |
| `requesting-code-review` | **Separate** - still useful for external/team review; implementation-review is self-review |
| `finishing-a-development-branch` | **Invoked** - called when user chooses "Done" after audit (after sync-with-base) |
| `using-git-worktrees` | **Prerequisite** - creates the worktree before workflow starts |
| `plan-complete` | **Invoked** - called after finishing to move plan from active/ to complete/ |

**Skills to modify:**
- `executing-plans` - add autonomous mode
- `using-gremlins` - add new skills to table

**No changes needed:**
- `verification-before-completion` - can coexist; implementation-review is the workflow gate
- `requesting-code-review` - different purpose (team review vs self-audit)
- `finishing-a-development-branch` - invoked as-is

---

## Implementation Scope

### In Scope
- New skill: `plan-readiness-review`
- New skill: `implementation-review`
- New skill: `reach-opportunities`
- New skill: `worktree-workflow`
- Modify: `executing-plans` (add autonomous mode, make it default)
- Update: `using-gremlins` (add new skills to table)

### Out of Scope
- System-level notifications (user handles separately)
- Parallel worktree management (one workflow per worktree)

---

## File Changes

```
skills/
├── plan-readiness-review/
│   └── SKILL.md                 # New
├── implementation-review/
│   └── SKILL.md                 # New
├── reach-opportunities/
│   └── SKILL.md                 # New
├── worktree-workflow/
│   └── SKILL.md                 # New
├── executing-plans/
│   └── SKILL.md                 # Modify (add autonomous mode)
└── using-gremlins/
    └── SKILL.md                 # Update (add new skills to table)
```

---

## Success Criteria

- [ ] `/plan-readiness-review` produces comprehensive pre-implementation analysis
- [ ] `/implementation-review` catches quality/completeness issues before merge
- [ ] `/reach-opportunities` identifies relevant quick wins without scope creep
- [ ] `/worktree-workflow` orchestrates full loop with state persistence
- [ ] `executing-plans` runs full plan without stopping by default
- [ ] Each phase produces clear interactive summary for human decision
- [ ] Can use skills standalone or through orchestrator
- [ ] State persists across Claude sessions in same worktree
- [ ] **Sync with base** before finishing presents rebase/merge options if base has advanced
- [ ] **Plan lifecycle** - plan moves from active/ to complete/ after workflow finishes
