# Docs before code

The human brings the vision. Before any issue exists, turn it into **ultra-detailed project docs with no grey zones**.

Of all the practices, this one pays off the most. Spending hours here is normal and good. Every gap left here becomes an agent guessing, inventing scope, or building the wrong thing later, and a fresh agent can't ask the conversation what was meant.

## How

- Run **several grilling rounds**: Claude interviews you relentlessly and writes the docs as it goes. A skill helps (we use `grill-with-docs` from Matt Pocock's skills = `grilling` + `domain-modeling`), but any grilling skill, or a disciplined chat, works. The rounds matter, not the tool.
- **One fresh session per round**, each with its own focus. Suggested rounds:
  1. Product: who it's for, the problem, what "done" looks like for v1
  2. Domain and vocabulary: every concept, its one name, the words to avoid
  3. Data model: entities, fields, relations, limits
  4. Money and limits: plans, quotas, what happens at the limit, downgrades
  5. Auth, permissions, security
  6. UX flows: every screen, every state (empty, loading, error, disabled)
  7. Edge cases and failure modes
  8. Out of scope: what v1 explicitly does not do
- Here Claude **asks, challenges and writes down**. The human decides. Claude proposes options only when asked.

## Fill the docs as you go

Write during the grilling, not after. A decision only said in chat is lost to the next agent.

- `docs/` decision files, one per topic, plus `docs/README.md` as the index
- `CONTEXT.md`: the glossary (term, definition, `_Avoid_:` words)
- `docs/adr/`: decisions with real trade-offs
- The Claude Project's own docs/memory, so the chat side stays in sync

## A design system, if there's a UI

Frontend agents work much better with a design system to follow. Without one, each agent invents its own colors, spacing and components, and the UI drifts a little more with every PR.

- **Ideally before the issues**: decide the look once, write it down, and every UI issue just follows it.
- **Or as the first issues**: "design system: tokens", then "base components", and every UI issue is blocked by them (see [issues as a testable chain](4-issues.md)).

What it holds, in the repo, readable by agents:
- **Tokens**: colors (light and dark), type scale and fonts, spacing, radius, shadows. One file (e.g. `tokens.json` or CSS variables).
- **Components**: the base set (button, input, select, dialog, tooltip…) with when to use each.
- **Rules**: what's forbidden (raw hex values, native selects, gradients…), how disabled, loading, empty and error states look.
- **A README** an agent reads before any UI work.

Make what you can a lint rule ("no raw hex", "no native `<select>`"): agents follow a failing lint better than a sentence.

## How a decision is written

- **Dated and attributed**: `(Sam, 2026-03-14)`.
- **With the why**: "Why: picking the folder automatically put public pages behind the login."
- **What it replaces**, when it changes something: "replaces the automatic folder pick from issue 42".
- Undecided ideas go in a **Questions for <human>** list, never in scope.

## Ready?

Signs the docs are ready:

- [ ] A fresh agent could build any part from the docs alone, without asking.
- [ ] Every number, limit, name and rule is written down.
- [ ] What is out of scope is written down.
- [ ] The glossary covers every term the issues will use.
- [ ] The **last grilling round found nothing new**. If it did, run another one.
