# Repo rules for fresh agents

Every agent starts with nothing. These files are all it gets.

## CLAUDE.md (or AGENTS.md)

Short and imperative. In this order:

1. One paragraph: what the product is.
2. **Repo map**: folder → what lives there. Say where things must NOT go.
3. **No unapproved scope** (the most important rule):
   - Build only what is in `docs/` or asked by the human in the issue/PR.
   - Need something undecided? Stop and ask in a comment. Never build it "for now" or "as an example".
   - Tickets: same rule. Ideas go under `## Questions for <human>`, never under `## Scope`.
   - A ticket can be wrong. If its scope isn't backed by `docs/`, ask first.
4. **Hard rules**: words to use and avoid, architecture rules, security rules.
5. **Tests**: feature first, few tests on logic that matters, no code changed only to be testable, run them yourself before pushing.
6. **Cost rules**: push once, never wait for CI.
7. **Workflow**: branch + draft PR, never push to main, assign the human, update `docs/` in the same PR when a decision changes.

Templates: `stacks/common/CLAUDE.md`, `stacks/common/CONTEXT.md`.

## Enforce with tools when you can

A tool can't forget. Mark tool-enforced rules in CLAUDE.md so agents know why the build fails:

- Lint rule → `(lint)` — e.g. no native `<select>`, no custom wrapper classes.
- Build failure → `(build)` — e.g. a package can't import from `back/`.
- `.claude/settings.json` → allow branch pushes, deny every push to main (`stacks/common/.claude/settings.json`).

## docs/README.md

An index: which file to read for which topic. Agents read only what their diff needs.

## One README per specialised area

When a kind of work has its own rules (videos, textures, emails), give it a README written for the agent that works there, including **where its output must go** and which folders are forbidden. Example: "Every video lives in `videos/`. Never make another video folder. Tools that pick their own output folder must follow this README."
