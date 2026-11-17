---
name: behalf
description: Run a software project as product owner + QA while fresh, specialised agents code, review and fix: airtight docs, testable issue chains, @claude delegation, review loops.
---

# behalf — agents build, you own the product

The human is **product owner and QA**. They no longer code. They hold the vision, make every decision, review PRs and test. Agents write, review and fix the code, on their behalf.

Use this skill to set up a new project this way, to bring a project already in progress into it, to plan a new chunk of work, or whenever you work in a project that already runs it.

## Where to start

- **New project** → phase 1.
- **Project already in progress** → [adopt.md](adopt.md): document what exists, then add the pipeline one piece at a time.

## Any issue tracker

GitHub Issues is the simplest (the executor wakes up on an issue comment), but Linear, Jira, Notion and other well-connected trackers work too. What the method needs from a tracker: issues, **native blocking links**, labels, and a way to start the executor. See [trackers.md](trackers.md).

## Scope

behalf is a method for **building software**: code, PRs, review, QA. Other work on the same product (marketing, content, sales) mostly runs outside it. Its principles still make good habits there: decide before doing, write decisions down, small checkable steps, fresh specialised agents, the human only steps in where they're needed.

## The method in 6 phases

| Phase | What | Read |
|---|---|---|
| 1 | **Airtight docs** with several grilling rounds (e.g. `grill-with-docs`). Must be perfect: hours here is normal. | [phases/1-docs.md](phases/1-docs.md) |
| 2 | **Repo rules** a fresh agent can follow (CLAUDE.md, docs index, glossary). | [phases/2-repo-rules.md](phases/2-repo-rules.md) |
| 3 | **Agent pipeline**: executor, reviewer, fix loop, status, conflicts, preview. | [phases/3-agent-pipeline.md](phases/3-agent-pipeline.md) |
| 4 | **Issues as a testable chain** (e.g. with `wayfinder`). Must be perfect: blocking edges decide what can be QA'd. | [phases/4-issues.md](phases/4-issues.md) |
| 5 | **Running the work**: the launcher starts issues, loops run, the human reviews ready PRs. | [phases/5-run.md](phases/5-run.md) |
| 6 | **Improving the system**: every repeated agent mistake becomes a rule. | [phases/6-improve.md](phases/6-improve.md) |

Phases 1 and 4 are the ones that must be done perfectly. Everything downstream inherits their gaps.

## Agents

- [agents/launcher.md](agents/launcher.md) — finds the next startable issues and comments `@claude do this` on them.
- [agents/executor-from-pr.md](agents/executor-from-pr.md) — **drive the agent from the PR**: `@claude`, inline comments, reviews, or just replying to Claude.
- [agents/conflict-fixer.md](agents/conflict-fixer.md) — **comments `@claude fix conflicts` on PRs that conflict after a merge**. Essential with many parallel PRs.
- [agents/build-map.md](agents/build-map.md) — draws the issue graph as an interactive map (template: [templates/build-map.html](templates/build-map.html)).
- The executor, reviewer, relay and conflict agents are GitHub Actions: see phase 3 and [stacks/](stacks/README.md).

## Core principles

1. **Agents run inside the repo.** Executor, reviewer and the rest run in CI on a checkout of the repo (GitHub Actions in the templates: the best fit today, not the only option): they read CLAUDE.md and docs/, run the build and the tests, and read CI. Full repo context, nothing to set up on the human's machine.
2. **Fresh, specialised agents.** Every agent starts empty and gets only the context its job needs. A narrow job needs a small model: the reviewer runs on Haiku because it only checks a diff against written rules. Use the cheapest model that is enough.
3. **Context lives in files, not in heads.** A fresh agent knows only what is written. Docs must be complete, dated, and say *why*.
4. **Code decides, models signal.** Models return structured output (verdict, confidence). Workflows read it and decide. No model loops forever or takes a costly action alone.
5. **One signal says whose turn it is.** Draft PR = an agent is working. Ready for review = the human's turn.
6. **Nothing undecided gets built.** Scope comes only from the docs or the human. An agent that needs something undecided asks and stops.
7. **A repeated agent mistake becomes a rule**, not a hand fix. That is why tickets go to agents, not to the chat: their mistakes are data.
8. **Automated tests in CI catch regressions.** At least on the backend (frontend optional). With many agents merging in parallel, CI is what keeps yesterday's feature working.
9. **Give agents the rights they need from day one.** Workflow permissions, allowed commands, build and test tools: set them up front. Agents can't edit their own workflows, so every missing right becomes a manual PR later. Still never merge, never push to main.
10. **Human attention is the scarcest resource.** Everything agents write is short and result-first, with a "Next step for you" line when the human must act. Put the human's reading needs in every agent prompt.

## Claude's role in chat

- Grills the human, writes decisions down, charts issues, launches work.
- Does **not** own the vision or the strategy: the human does. Claude challenges, proposes when asked, explains simply.
- Does **not** code issues (except when asked, or for `.github/workflows/` files the GitHub agent can't change).
- Never adds scope. Anything new is a question for the human.
