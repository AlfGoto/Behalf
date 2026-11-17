# The agent pipeline

GitHub Actions agents built on `anthropics/claude-code-action`. Working files for two stacks are in [stacks/](../stacks/README.md). Adapt the commands and rules, keep the mechanics.

## The agents

| Agent | Trigger | Model | Can do |
|---|---|---|---|
| **Executor** (`claude.yml`) | `@claude` on an issue/PR (comment, inline comment or review), or any human reply to a Claude comment | Sonnet | Code, run the tests of the touched folder, open a **draft** PR assigned to the human with `Fixes #n` |
| **Reviewer** (`claude-review.yml`) | Every PR push, except docs-only PRs | Haiku | Comment only. Never approve, never merge |
| **Relay** (extra step) | Reviewer verdict = `fix` | Haiku, 3 turns, 1 command | Post "@claude please fix (round n/3)" |
| **Conflict fixer** | After main changes | Haiku relay | Comment "@claude fix conflicts" on PRs that now conflict. **Essential with many parallel PRs**: [agents/conflict-fixer.md](../agents/conflict-fixer.md) |
| **Preview** | `/preview` comment or a preview deploy | none | A live place for the human to test the PR |
| **Launcher** | On demand, schedule, or after a merge | small | Start the next issues: [agents/launcher.md](../agents/launcher.md) |

**They run inside the repo.** Each agent is a GitHub Actions job on a checkout of the PR branch: it reads CLAUDE.md, docs/ and the code, installs dependencies, builds, runs the tests, and reads CI results. It has the whole repo as context, and the human installs nothing locally. This is what makes a small model enough for the review: it doesn't need to be told the project, it reads it.

Why so many small agents: a narrow job with a short context is more reliable and needs a cheaper model. The reviewer doesn't need to understand the product, only to check a diff against written rules.

## The PR is the control panel

The human can start an agent from any PR: `@claude` in a comment, an inline comment or a review, or just a reply under a Claude comment. Details and wiring: [agents/executor-from-pr.md](../agents/executor-from-pr.md). Don't skip this: it's how the human steers without ever checking out code.

## CI tests (catch regressions)

Many agents merging in parallel will break each other's work unless CI catches it.

- **Backend: automated tests in CI, on every PR.** Focus on the logic that matters (limits, auth, tokens, money, anti-exploit). This is the one to have.
- **Frontend: optional.** At least lint + build; a few tests on important logic if useful.
- **Libraries / packages / CLIs** that users install: a real build test (build what the user would build), so fixed bugs stay fixed.
- Path filters: each test workflow runs only when its folder changes. Docs-only PRs run nothing.
- The executor runs the tests of the folder it touched **before** pushing (green locally = green CI). The reviewer reads the CI result once and blocks on red.
- Feature first, tests second: few, simple tests. No snapshot tests, no code changed only to be testable.

Examples: `stacks/node/.github/workflows/test-back.yml`, `test-front.yml`; `stacks/java-gradle/.github/workflows/test.yml`.

## Reviewer checklist (in this order)

0. **Unapproved scope**: anything not in docs/ or asked by the human = fix first. The reviewer's own ideas are suggestions, never scope.
1. Matches docs and glossary (names, architecture rules).
2. Bugs.
3. Security / exploits.
4. Tests: read CI **once** (`gh pr checks`, never `--watch`). Missing tests on trivial code is not a reason to block.
5. Docs updated if a decision changed.
6. Is there a simpler way? List what isn't needed.
7. "How to test" is correct, complete and works on this branch.

## Structured output

The reviewer returns JSON (`--json-schema`):

- `verdict`: `good` | `fix`
- `confidence` 0–5: **how safe it is to merge without manual QA**.
  - 5: nothing user-facing changes, or trivial.
  - 4: small, isolated, tested; worst case is minor.
  - 3: tests pass but it depends on how it feels, or touches a shared system. Quick test advised.
  - 2: core loop, many edge cases, possible exploit. Test it.
  - 1: big or risky. 0: CI fails or can't work.
  - `fix` → 2 at most.

The workflow puts the score in the PR title (`4/5 Add CSV export`), so the human triages at a glance.

## Fix loop

- Reviewer says `fix` → relay asks the executor to fix → executor pushes → reviewer runs again.
- **Capped at 3 rounds**, counted with a hidden HTML marker in reviews (`<!-- project-autofix -->`). Then the human is pinged once and the loop goes quiet.
- The executor may **disagree**: it replies to the comment instead of changing the code.
- Stops early when the executor has nothing to push.

## Status = whose turn

- Fix round running → **draft**.
- Verdict good, loop stopped, or review failed → **ready for review**.
- The executor opens PRs as draft, goes back to draft before pushing, and marks ready if it ends without pushing (otherwise the PR would stay draft forever).

## Comments

- **One summary comment per PR**, edited each run (`gh pr comment --edit-last --create-if-none`). Old points marked ✅ fixed or still open.
- Never repeat an inline comment already made.
- Written for the human: verdict and must-fix first, short lines, bold the key point.

## Permissions: give them what they need, up front

Agents can't edit `.github/workflows/`. So every right you forget becomes a stuck run, then a manual PR to add it. Decide the rights once, at setup, for each agent's whole job:

- **Workflow `permissions:`**: executor needs `contents: write`, `pull-requests: write`, `issues: write`, `id-token: write`, plus `actions: read` and `checks: read` to read CI. Reviewer: `pull-requests: write`, `contents: read`, `checks: read`, `actions: read`.
- **`additional_permissions`** on the action (`actions: read`, `checks: read`) so Claude can read CI results.
- **`--allowedTools`**: every command the job needs. Executor: git fetch/pull/merge/add/commit + read-only git, `gh pr create/view/diff/checks/comment/edit`, `gh issue view/comment`, `cd`, and **every build, install and test command of your stack** (package manager, compiler, test runner, code generators). Anything not listed is refused mid-run.
- **Stack setup step** (language runtime, dependency cache) so the agent can actually build and test.
- **Bots**: `allowed_bots: "claude[bot]"` so relays and fixes can trigger runs; on stacks where the action refuses build commands on bot-authored PRs, trust PRs written by `claude[bot]` only (see `stacks/java-gradle/README.md`).
- **Turns and time**: `--max-turns` high enough for real issues (60 for the executor), `timeout-minutes` to stop stuck runs.

Then hold the line on what they must never do: no rebase, reset, force push, merge, or push to main. Reviewer: read + comment on its own PR only. Relays: one command.

When an agent hits a missing right anyway: add it to the workflow in one PR (Claude opens it, since the GitHub agent can't), and note it here for the next project.

## Cost
- Push once, at the end. Never wait or poll CI: the runner is billed while it waits.
- Run only the tests of the touched folder.
- `paths-ignore` docs for the review (docs-only PRs cost 0 minutes; give them `5/5`).
- `timeout-minutes` on every job. `cancel-in-progress` for the review, but a **queue** (no cancel) for the executor, so a random comment never replaces a real `@claude` request.

## PR template

"How to test" first, as checkboxes:

- Start with how to open the preview.
- Every command written out in full, ready to copy, then `→` what the human should see.
- The agent checks every step works on the branch, and finds real commands and ids in the code. Never guesses.
- "Can't test by hand" + which test covers it.
- A "Needs your answer" line only if the human must decide.
- Everything else (What, Why, Docs updated?) folded in `<details>`.

## Two GitHub traps

1. A comment posted with `GITHUB_TOKEN` never triggers another workflow. Relays are posted by a tiny extra Claude step, which gets a fresh App token.
2. `claude-code-action` refuses `push` events. Trigger on "PR closed + merged", or use `workflow_dispatch` from a plain job.
