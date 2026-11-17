# Adopting behalf on a project already in progress

You don't need to start from zero. Bring an existing project in step by step. Each step pays off on its own.

## 1. Write down what already exists

The code holds decisions nobody wrote down. A fresh agent can't guess them.

- Run grilling rounds (e.g. `grill-with-docs`) **on the existing project**: Claude reads the code and the current docs, then grills the human on what it finds ("Is this limit on purpose?", "Two names for the same thing: which one is right?").
- Write each decision in `docs/` as it's confirmed: dated, attributed, with the why. Mark old choices you keep but wouldn't make again ("legacy, keep as is").
- Build the glossary (`CONTEXT.md`) from the names already in the code, with the `_Avoid_` words for the duplicates.
- Same exit criteria as [phase 1](phases/1-docs.md), but only for the parts you'll touch next. The rest can be documented when work reaches it.

## 2. Add the repo rules

Write `CLAUDE.md` and `docs/README.md` ([phase 2](phases/2-repo-rules.md)). Turn the rules the team already follows by habit into lint rules where you can.

## 3. Install the pipeline in order

**First, CI tests** if there are none: at least on the backend. With agents merging in parallel, they're what stops regressions.

Then the agents. Each piece works alone, so add them one at a time ([phase 3](phases/3-agent-pipeline.md), files in [stacks/](stacks/README.md)):

1. **Executor** (`claude.yml`): you can already say `@claude` on issues and PRs.
2. **Reviewer + fix loop + status**: PRs now arrive reviewed, with a confidence score.
3. **Conflict fixer**: needed as soon as several PRs run in parallel.
4. **Preview**: if the project has no preview env yet, this is often the biggest win for QA.
5. **Launcher**: last, once the issues have clean blocking links.

## 4. Turn the backlog into a testable chain

- Keep your current tracker (GitHub Issues, Linear, Jira, Notion…) if it has native blocking links: see [trackers.md](trackers.md).
- Pass the existing open issues through [phase 4](phases/4-issues.md): rewrite each one so it stands alone, and add the missing blocking links.
- Close or park what is not decided. Ideas go under "Questions for <human>".
- Run the [build map](agents/build-map.md): issues in an early wave that can't be tested there are missing blocking links.

## 5. Start small

Launch a few small, isolated issues first. Watch where agents go wrong, turn each mistake into a rule ([phase 6](phases/6-improve.md)), then widen.
