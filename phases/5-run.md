# Phase 5 — Running the work

## The loop

1. **Launch.** The [launcher agent](../agents/launcher.md) finds the frontier (open issues whose blockers are all closed) and comments **`@claude do this`** on each. More practical than the human doing it: it never forgets a newly unblocked issue.
2. **Build.** The executor opens a draft PR.
3. **Review ↔ fix.** The reviewer and executor loop (max 3 rounds) without the human.
4. **Ready.** The PR turns ready for review, with `N/5` in its title.
5. **QA.** The human looks **only at ready PRs**: the score first, then the "How to test" on the preview.
6. **Merge.** The human merges. The issue closes (`Fixes #n`), and two agents react:
   - the [conflict fixer](../agents/conflict-fixer.md) comments `@claude fix conflicts` on every PR that now conflicts, so parallel PRs stay mergeable;
   - the launcher starts what just got unblocked.

## Steering from the PR

Want a change, an answer, or a fix? Say it on the PR: `@claude …`, an inline comment on the line, a review, or just reply under Claude's comment. The agent picks it up, the PR goes back to draft while it works, and comes back ready. See [agents/executor-from-pr.md](../agents/executor-from-pr.md).

## Who answers what

- Agents ask questions on issues. Claude settles everything it can (numbers, implementation details) and passes on **only what only the human can decide**.
- Changes to `.github/workflows/`: the GitHub agent can't make them, so Claude opens those PRs itself.

## Bugs

List **5 possible causes**, pick the most likely, check it, and only then propose a fix.

## Seeing the whole picture

The [build map](../agents/build-map.md) shows every issue, its blockers and what it unlocks, with a progress percentage. Update it when the human asks where things stand.
