# behalf

[![skills.sh](https://skills.sh/b/AlfGoto/Behalf)](https://skills.sh/AlfGoto/Behalf)

A Claude skill that collects **good practices** for building software as **product owner + QA** while fresh, specialised agents code, review and fix, on your behalf.

Not a strict method: take what fits your project. The practices that pay off most: docs with no grey zones before any code, issues chained so every merge can be tested right away, and PRs you only look at when a status says it's your turn.

## Used in production

These practices were used to build [Flocon AI](https://flocon-ai.com), a tool to create and publish SEO pages on your own website straight from your AI assistant (Claude, Cursor…) through an MCP server.

## What's inside

```
SKILL.md                  entry point: the practices + the principles behind them
adopt.md                  bring the practices into a project already in progress
trackers.md               GitHub Issues, Linear, Jira, Notion: what the tracker must do
practices/
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

Works on a new project or one already in progress (`adopt.md`). Take what fits.

## What you need

**Needed for the full pipeline**
- A code host where agents can run inside the repo on each issue and PR. **GitHub + `anthropics/claude-code-action`** is the best fit today, and all templates here use it. Other hosts can work with the same ideas.
- An issue tracker with **native blocking links**: GitHub Issues, Linear, Jira, Notion… (`trackers.md`).
- **Automated tests in CI**, at least on the backend, so parallel merges don't bring regressions.

**Recommended, not required**
- A grilling skill for writing the docs. We use `grill-with-docs` from [Matt Pocock's skills](https://github.com/mattpocock/skills); any skill that interviews you and writes docs as it goes works, and so does a disciplined chat.
- A ticketing skill that creates issues **with blocking links**. We use `wayfinder` (same repo); any other works, or write the issues by hand. What matters is the testability rule, not the tool.

**Optional**
- `gh` and `jq`, only to run `templates/build-map-data.sh`. Any agent with access to your tracker can produce the same JSON instead.

## Install

With the [skills CLI](https://skills.sh):

```
npx skills add AlfGoto/Behalf
```

Or clone it:

```
git clone https://github.com/AlfGoto/behalf ~/.claude/skills/behalf
```

Or copy the folder into your skills folder, or upload it as a skill in Claude.

## The two steps to never rush

1. **Docs** (docs before code): grill until a round finds nothing new. Hours is normal.
2. **Issues** (issues as a testable chain): an issue that can't be tested without another is blocked by it, so the human can QA every merge right away.
