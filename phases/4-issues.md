# Phase 4 — Issues as a testable chain

Use **`wayfinder`** (Matt Pocock) to chart the work as issues with **native blocking links** on the tracker (GitHub Issues, Linear, Jira, Notion…: see [trackers.md](../trackers.md); `wayfinder` asks which tracker via `setup-matt-pocock-skills`). The human reads them before any work starts.

## Issue rules

- **Small but not tiny**: one agent session, one focused PR. Small PRs make the Haiku reviewer precise.
- **Global → precise**: foundations first, then features, then polish.
- **Stands alone**: a fresh agent gets only the issue + the docs. Link the doc sections it needs.
- **Only decided scope.** Open questions go under "Questions for <human>".
- **Labels** that the launcher and the map read: area (`front`, `back`…), `hitl` (needs the human: an account, a secret, a decision), `grilling` (a decision ticket, not code).
- **Uses the current state of the repo**: when real assets exist (textures, components), new issues use them, not placeholders.

## The testability rule (most important)

**An issue that cannot be tested without another issue is blocked by it. It is never coded in parallel, and never merged before it.**

The human is QA. Every merge must be testable end to end, right away, on the preview, using only what is already merged.

> Real mistake: the issue that blocked dashboard access without an account was merged. Then the dashboard pages were coded **before** account creation existed. Nobody could log in, so nothing could be tested.

### Check every issue

1. **Reach**: when this merges, can the human reach it with only merged issues? If not, which issue makes it reachable? Add that blocking link.
2. **Doors**: does it close a door (auth gate, permission check, paywall, redirect, required field)? Then the way through the door (sign-up, login, the right plan) must be merged first, or be in the same issue.
3. **Data**: does it need data to show anything? The thing that creates the data comes first.
4. **No UI yet**: if it can only be checked by a test, say so in the issue and name the test.

### Then walk the whole graph

Go through the merge order from the start. At each step, ask: "Could the human QA this right now, on the preview, with what is merged?" Any "no" is a missing blocking link.

Also check the reverse: two issues that would change the same files at the same time should not both be startable. Block one by the other, or merge them.

## Before publishing

- [ ] Every issue passes the 4 checks.
- [ ] The graph walk has no "no".
- [ ] `hitl` issues (accounts, secrets, DNS, payments setup) are blockers of what needs them, so the human sees them early.
- [ ] The human has read the issues.
