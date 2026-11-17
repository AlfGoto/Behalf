---
name: behalf
description: "Good practices for building software as product owner + QA while fresh, specialised agents code, review and fix: docs first, testable issue chains, @claude delegation, review loops."
---

# behalf — agents build, you own the product

A collection of **good practices** for working with coding agents, gathered from real projects where the human acts as **product owner and QA** and agents write, review and fix the code, on their behalf.

This is not a strict method. Pick the practices that fit your project, in any order, and adapt them. Each one helps on its own; together they let you run many agents in parallel while you only decide, review and test.

## How to use this skill

- When the user starts a project, plans work, sets up agents, or asks how to work better with agents: suggest the practices that fit their situation, not the whole list.
- When a project already follows some of them, respect what's there and suggest the next most useful one.
- Never impose a tool. The skills, trackers and CI named here are what worked for us; anything that does the same job is fine.

## The practices

| Area | In short | Read |
|---|---|---|
| **Docs before code** | Write the product down with no grey zones, through grilling rounds, before any issue exists. If there's a UI, a design system too. | [practices/1-docs.md](practices/1-docs.md) |
| **Repo rules for fresh agents** | Short CLAUDE.md, docs index, glossary, rules enforced by tools. | [practices/2-repo-rules.md](practices/2-repo-rules.md) |
| **The agent pipeline** | Executor, reviewer, fix loop, merge confidence, whose-turn status, conflicts, preview, CI tests, rights. | [practices/3-agent-pipeline.md](practices/3-agent-pipeline.md) |
| **Issues as a testable chain** | Small issues with blocking links, so every merge can be tested right away. | [practices/4-issues.md](practices/4-issues.md) |
| **Running the work** | Launch issues, let the loops run, review only ready PRs, steer from the PR. | [practices/5-run.md](practices/5-run.md) |
| **Improving the system** | Every repeated agent mistake becomes a rule. | [practices/6-improve.md](practices/6-improve.md) |

**If you only take two:** docs with no grey zones, and issues that block each other so nothing untestable gets built in parallel. These two pay off the most, and every other practice inherits their gaps.

Other pages:
- [adopt.md](adopt.md) — bringing these practices into a project already in progress, one at a time.
- [trackers.md](trackers.md) — GitHub Issues, Linear, Jira, Notion: what a tracker needs to support these practices.
- [stacks/](stacks/README.md) — workflow templates (GitHub Actions) for Node and Java/Gradle.

## Agents

- [agents/launcher.md](agents/launcher.md) — finds the next startable issues and comments `@claude do this` on them.
- [agents/executor-from-pr.md](agents/executor-from-pr.md) — drive the agent from the PR: `@claude`, inline comments, reviews, or just replying to Claude.
- [agents/conflict-fixer.md](agents/conflict-fixer.md) — comments `@claude fix conflicts` on PRs that conflict after a merge. Very useful with many parallel PRs.
- [agents/build-map.md](agents/build-map.md) — draws the issue graph as an interactive map.

## Principles behind the practices

1. **Agents run inside the repo.** In CI, on a checkout: they read CLAUDE.md and docs/, build, test, and read CI. Full repo context, nothing to set up on the human's machine.
2. **Fresh, specialised agents.** Each agent starts empty with only the context its job needs. A narrow job needs a small model: a reviewer that checks a diff against written rules runs fine on Haiku.
3. **Context lives in files, not in heads.** A fresh agent knows only what is written, so write decisions down, dated, with the why.
4. **Code decides, models signal.** Models return structured output (verdict, confidence); workflows read it and act. No model loops forever or takes a costly action alone.
5. **One signal says whose turn it is.** Draft PR = an agent is working. Ready for review = the human's turn.
6. **Nothing undecided gets built.** Scope comes from the docs or the human. An agent that needs something undecided asks.
7. **A repeated agent mistake becomes a rule**, not a hand fix. Their mistakes are data.
8. **Automated tests in CI catch regressions**, at least on the backend. With many agents merging in parallel, CI keeps yesterday's feature working.
9. **Give agents the rights they need from day one.** Agents can't edit their own workflows, so every missing right becomes a manual PR later. Still never merge, never push to main.
10. **Human attention is the scarcest resource.** Agents write short, result-first messages, with a "Next step for you" line when the human must act.

## Scope

These practices are about **building software**: code, PRs, review, QA. Other work on the same product (marketing, content, sales) mostly runs outside them, but the principles still make good habits there.

## Claude's role in chat

- Helps the human grill their ideas, writes decisions down, charts issues, launches work.
- Doesn't own the vision or the strategy: the human does. Claude challenges, proposes when asked, explains simply.
- Leaves coding issues to the agents in the repo (unless asked, or for workflow files those agents can't change).
- Doesn't add scope. Anything new is a question for the human.
