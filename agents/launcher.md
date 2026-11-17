# Launcher agent

Starts the next issues so the human doesn't have to. It finds every issue that can start now and comments `@claude do this` on it. That comment wakes the executor (`claude.yml`).

More practical than doing it by hand: right after a merge, it never forgets an issue that just got unblocked.

## When to run it

- On demand, from chat: "launch the next issues".
- After each merge (a workflow on `pull_request: closed` + merged, built like `stacks/common/.github/workflows/fix-conflicts.yml`: a plain job finds the issues, a tiny Claude step posts the comments so they trigger other workflows).
- On a schedule, if the team prefers batches.

Use a small model (Haiku): the job is a filter plus one comment per issue.

## Which issues to start

Start an issue only if **all** are true:

1. It is **open**.
2. Every issue in its **"blocked by" list is closed** (REST: `GET repos/{owner}/{repo}/issues/{n}/dependencies/blocked_by`).
3. **No open PR** already says `Fixes #n` (or Closes / Resolves).
4. It was **not launched already**: no earlier `@claude do this` comment, and no comment from `claude[bot]` on it.
5. It is **not human work or a decision**: no `hitl` label, no `grilling` / `wayfinder:grilling` / `wayfinder:prototype` label, not the `wayfinder:map` issue.

Optional, if the human sets it: a **cap** on how many agent PRs can be open at once (count open PRs by `claude[bot]`). Start the issues that unlock the most work first.

## What to post

On each chosen issue, exactly:

```
@claude do this
```

Nothing else in the comment.

## What to report

One short message to the human:

- **Started**: issue names (title, linked).
- **Waiting on you**: unblocked issues with `hitl`, so the human sees them.
- **Skipped**: anything unusual (e.g. a closed blocker whose PR was closed without merge).

## Prompt (for chat or a scheduled task)

```
You launch work on <owner>/<repo>. Use the GitHub REST API only.
1. List open issues (not PRs). Skip any with the labels hitl, grilling, wayfinder:grilling, wayfinder:prototype, wayfinder:map.
2. For each one, read GET repos/<owner>/<repo>/issues/<n>/dependencies/blocked_by. Keep it only if every blocker is closed.
3. Drop it if an open PR body contains "Fixes #<n>", "Closes #<n>" or "Resolves #<n>".
4. Drop it if any comment already contains "@claude do this" or comes from claude[bot].
5. Comment exactly "@claude do this" on each issue left. Nothing else.
6. Report: started issues (by title), unblocked hitl issues waiting on the human, anything skipped for an odd reason.
Never close, edit or label issues. Never comment anywhere else.
```
