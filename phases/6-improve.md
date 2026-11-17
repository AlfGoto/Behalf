# Phase 6 — Improving the system

## Mistakes become rules

- An agent makes the same mistake twice → add a line to CLAUDE.md, `docs/`, or the agent's prompt. Don't fix it by hand and move on.
- Every odd rule in a prompt is a scar from a real error ("never post a Create PR link", "never write the body in /tmp"). Keep them.
- Prefer a tool over a sentence: a lint rule or a failing build beats a line nobody reads.

## Docs stay the truth

- A decision changes → `docs/` updated **in the same PR**.
- Keep the project docs and the chat-side memory up to date, so the next fresh agent starts from the truth.
- Before proposing any task, check what's already done. Never propose finished work.

## Simulations for risky, user-facing pieces

For installers, onboarding, setup flows: run **simulation rounds**.

1. Agents play users on real setups (each framework, each version, odd configs).
2. Each round's failures, sorted by severity, become one PR.
3. Add a real build test that runs what the users would run, so fixed bugs stay fixed.
4. Repeat until a round finds nothing serious.

## Retro

After a big chunk of work, ask: where did the human have to step in? Each answer is a missing rule, a missing doc, or a missing blocking link.
