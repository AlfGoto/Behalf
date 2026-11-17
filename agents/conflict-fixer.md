# Conflict fixer

**Essential as soon as many PRs run in parallel.** Each merge on main can put other open PRs in conflict. Without this, the human ends up rebasing by hand, or PRs go stale.

## What it does

After main changes, it finds every open PR that now has merge conflicts and comments:

```
@claude fix conflicts
```

That comment wakes the executor, which merges main into the PR branch, fixes the conflicts, runs the tests and pushes. The review then runs again, as for any push.

## Rules

- **Trigger**: after a PR is merged into main (`pull_request: closed` + `merged == true`). `claude-code-action` refuses `push` events; alternative: a plain job on `push` that starts the workflow again with `workflow_dispatch`.
- **Wait for GitHub**: `mergeable` is computed in the background after a merge. It's `null` / `UNKNOWN` at first: ask, wait a few seconds, ask again.
- **Only `dirty` PRs** (real conflicts).
- **Don't ask twice**: if the last comment on the PR is already `@claude fix conflicts` and nothing happened since, skip it.
- **The comment must come from a Claude step**, not from `GITHUB_TOKEN`: comments made with `GITHUB_TOKEN` never trigger other workflows. A tiny Claude step (Haiku, one allowed command: `gh pr comment`) posts it.
- **Merge, never rebase**: the executor may `git fetch`, `git merge`, `git add`, `git commit`. No rebase, no reset, no force push.

## Why a comment instead of calling the agent directly

Same path as a human asking: the executor gets the PR's context, and the per-PR queue in `claude.yml` keeps runs from colliding.

Working file: `stacks/common/.github/workflows/fix-conflicts.yml` (runs on merge).
