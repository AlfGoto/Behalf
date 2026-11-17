# <Project name>

<One paragraph: what the product is and who it's for.>

## Repo map
- `<folder>/` — <what lives here>.
- `<folder>/` — <what lives here>. **Never** put <X> here.
- `docs/` — all project decisions. **Read `docs/README.md` first.**
- `.github/workflows/` — tests + Claude agents.

## No unapproved scope (most important rule)
- **Build only what <owner> decided.** A thing is decided when it is in `docs/` or <owner> asked for it in the issue/PR.
- Never add anything else on your own: no extra route, endpoint, page, package, field, setting, limit, UX rule or "example" code.
- Need something not decided? **Stop and ask in a comment.** Do not build it "for now" or "as an example".
- Writing tickets: same rule. Only decided scope. Ideas go under `## Questions for <owner>`, never under `## Scope`.
- A ticket can be wrong. If its scope is not backed by `docs/`, ask before doing it.

## Hard rules
- Words: use the glossary (`CONTEXT.md`). "<right word>", never "<wrong word>".
- <Architecture rule>. (lint)
- <Security rule: who can write what, sanitizing, no secrets in code>.
- <A rule the build enforces>. (build)

## UI
- **UI work → read `docs/design-system/README.md` first.** Use its tokens and components. Never paste raw colors, sizes or fonts.
- <A UI rule the lint enforces, e.g. no native `<select>`>. (lint)

## Tests
- **Feature first.** Code the feature, then add tests if it makes sense.
- Few, simple tests on the logic that matters (<limits, auth, money…>). No tests for trivial code.
- Never add code, layers or abstractions just to make something testable. No snapshot tests.
- **Run the tests yourself before pushing**, only for the folder you changed: `<command>`. Green locally = green CI.
- **Never wait for CI** (no `gh pr checks --watch`, no sleep loops). CI runs on its own; the review reads the result.

## GitHub Actions minutes (they cost money)
- **Push once**, at the end. Every push = a new review run + CI run.
- Don't run tests of a folder you didn't touch.
- New/changed workflow: `paths:` filter, `concurrency` with `cancel-in-progress: true` (except `claude.yml`: it queues agent runs), `timeout-minutes`, dependency cache.

## Workflow
- Work on a branch, open a PR. **Never push to `main`.** <owner> reviews and merges.
- **Open every PR as a draft.** The review workflow marks it ready when it's <owner>'s turn.
- Assign <owner> on every PR you open.
- If a change contradicts `docs/`, stop and say so.
- When a decision changes, update `docs/` in the same PR.
- Write in simple English: short sentences, lists.
