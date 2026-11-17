# Stacks

The workflows come from real projects that run this method, with the project details taken out. Replace every `<…>` and `your-github-login`.

```
common/                         every project
  .github/workflows/claude.yml          executor (Sonnet): @claude, inline comments, reviews, plain replies
  .github/workflows/claude-review.yml   reviewer (Haiku) + fix loop (3 rounds) + status + N/5 confidence
  .github/workflows/fix-conflicts.yml   "@claude fix conflicts" on PRs that conflict after a merge
  .github/pull_request_template.md      How to test first, the rest folded
  .claude/settings.json                 local sessions: push branches, never main
  CLAUDE.md                             rules for fresh agents (template)
  CONTEXT.md                            glossary with _Avoid_ words (example)
  alternatives/fix-conflicts-on-push.yml  same as fix-conflicts.yml, also covers direct pushes to main
node/                           setup step, allowed commands, test-back.yml, test-front.yml
java-gradle/                    setup step, allowed commands, test.yml,
                                preview-game-server.yml (/preview = live Paper server per PR)
```

## Install

1. Copy `common/` into your repo root.
2. In `claude.yml` and `claude-review.yml`, fill in the `env:` block (your GitHub login, your stack's commands, your project checks).
3. Replace the `STACK SETUP` comment in `claude.yml` with your stack's setup step (`node/README.md`, `java-gradle/README.md`).
4. Copy your stack's test workflow(s). Backend tests in CI: have them.
5. Add the repo secret `CLAUDE_CODE_OAUTH_TOKEN` and install the Claude GitHub app on the repo.
6. Fill in `CLAUDE.md` and `CONTEXT.md` from your docs (phase 1).

Check the model names in `claude_args` match the current Claude models.

**Rights:** give each agent everything its job needs now (permissions, `--allowedTools`, stack setup). The agent can't edit workflows, so a missing right means a manual PR later. See phases/3-agent-pipeline.md.

## Two GitHub traps these files already solve

1. A comment posted with `GITHUB_TOKEN` never triggers another workflow. So relays ("@claude please fix", "@claude fix conflicts") are posted by a tiny extra Claude step (Haiku, 3 turns, one allowed command), which gets a fresh App token.
2. `claude-code-action` refuses `push` events. `fix-conflicts.yml` triggers on "PR closed + merged" instead.
