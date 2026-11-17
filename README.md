# behalf

A Claude skill for building software as **product owner + QA** while fresh, specialised agents code, review and fix, on your behalf.

You write airtight docs, chart issues that can be tested one after the other, and only look at PRs when a status says it's your turn. Agents do the rest.

## What's inside

```
SKILL.md                  entry point: principles + the 6 phases
adopt.md                  bring a project already in progress into behalf
trackers.md               GitHub Issues, Linear, Jira, Notion: what the tracker must do
phases/
  1-docs.md               airtight docs with several grilling rounds
  2-repo-rules.md         CLAUDE.md, docs index, glossary, tool-enforced rules
  3-agent-pipeline.md     executor, reviewer, fix loop, confidence score, status, costs
  4-issues.md             issues with blocking links + the testability rule
  5-run.md                launch, review loop, QA, merge
  6-improve.md            mistakes become rules, simulations, retro
agents/
  launcher.md             finds startable issues and comments "@claude do this"
  executor-from-pr.md     drive the agent from the PR (@claude, inline, review, plain reply)
  conflict-fixer.md       "@claude fix conflicts" on PRs that conflict after a merge
  build-map.md            interactive map of the issue graph
templates/
  build-map.html          the map (paste your data in)
  build-map-data.sh       GitHub issues + blocking links → map data
stacks/                   ready-to-adapt workflows and templates
  common/                 executor, reviewer + fix loop, conflict fixer, PR template, CLAUDE.md, glossary
  node/                   Node / TypeScript setup + CI tests
  java-gradle/            Java / Gradle setup + CI tests + /preview notes
```

## Scope

Made for **building software**. Marketing, content or sales on the same product mostly run outside it, but the principles (decide first, write it down, small checkable steps, the human only where needed) are good habits there too.

Works on a new project (start at phase 1) or one already in progress (start with `adopt.md`).

## What you need

**Required**
- A code host where agents can run inside the repo on each issue and PR. **GitHub + `anthropics/claude-code-action`** is the best fit today, and all templates here use it. Other hosts can work with the same ideas.
- An issue tracker with **native blocking links**: GitHub Issues, Linear, Jira, Notion… (`trackers.md`).
- **Automated tests in CI**, at least on the backend, so parallel merges don't bring regressions.

**Recommended, not required**
- A grilling skill for phase 1. We use `grill-with-docs` from [Matt Pocock's skills](https://github.com/mattpocock/skills); any skill that interviews you and writes docs as it goes works, and so does a disciplined chat.
- A ticketing skill for phase 4 that creates issues **with blocking links**. We use `wayfinder` (same repo); any other works, or write the issues by hand. What matters is the testability rule, not the tool.

**Optional**
- `gh` and `jq`, only to run `templates/build-map-data.sh`. Any agent with access to your tracker can produce the same JSON instead.

## Install

```
git clone https://github.com/AlfGoto/behalf ~/.claude/skills/behalf
```

Or copy the folder into your skills folder, or upload it as a skill in Claude.

## The two steps to never rush

1. **Docs** (phase 1): grill until a round finds nothing new. Hours is normal.
2. **Issues** (phase 4): an issue that can't be tested without another is blocked by it, so the human can QA every merge right away.
