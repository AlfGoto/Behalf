# Phase 1 — Airtight docs

The human brings the vision. Before any issue exists, turn it into **ultra-detailed project docs with no grey zones**.

This is the most important phase. Spending hours here is normal and good. Every gap left here becomes an agent guessing, inventing scope, or building the wrong thing later, and a fresh agent can't ask the conversation what was meant.

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
- In this phase Claude **asks, challenges and writes down**. The human decides. Claude proposes options only when asked.

## Fill the docs as you go

Write during the grilling, not after. A decision only said in chat is lost to the next agent.

- `docs/` decision files, one per topic, plus `docs/README.md` as the index
- `CONTEXT.md`: the glossary (term, definition, `_Avoid_:` words)
- `docs/adr/`: decisions with real trade-offs
- The Claude Project's own docs/memory, so the chat side stays in sync

## How a decision is written

- **Dated and attributed**: `(Sam, 2026-03-14)`.
- **With the why**: "Why: picking the folder automatically put public pages behind the login."
- **What it replaces**, when it changes something: "replaces the automatic folder pick from issue 42".
- Undecided ideas go in a **Questions for <human>** list, never in scope.

## Exit criteria

Leave this phase only when all are true:

- [ ] A fresh agent could build any part from the docs alone, without asking.
- [ ] Every number, limit, name and rule is written down.
- [ ] What is out of scope is written down.
- [ ] The glossary covers every term the issues will use.
- [ ] The **last grilling round found nothing new**. If it did, run another one.
