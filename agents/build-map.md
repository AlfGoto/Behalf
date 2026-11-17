# Build map agent

Draws every issue as an interactive map: one card per issue, one row per area, left → right in **waves** (an issue sits one wave after its last blocker). It's a gadget, but a good one: you see at a glance what's done, what can start, what's waiting on you, and what each issue unlocks.

- Hover a card → its whole chain lights up (orange = needs first, blue = unlocks next).
- Click → details: blockers, what it unlocks, "frees N tasks right away, M down the chain", PRs, GitHub link.
- Side panel: in progress, **ready (comment @claude do this)**, needs you, sorted by how much each one unblocks.
- Filters by status and area, search by `#num` or title, zoom, pan. Light and dark.

## Statuses

| Status | Rule |
|---|---|
| done | issue closed |
| progress | open, with an open PR that says `Fixes #n` |
| blocked | open, at least one blocker still open |
| hitl ("needs you") | open, unblocked, label `hitl` |
| ready | open, every blocker closed |

## How to build or update it

1. Get the data (REST only, works where GraphQL is blocked):
   ```
   templates/build-map-data.sh <owner>/<repo> > data.json
   ```
   Areas come from `area:<name>` labels (else from the plain labels). The `wayfinder:map` issue is left out.
2. Copy `templates/build-map.html`. In the `EDIT ME` block, set `CONFIG` (title, repo URL, update time, optional lane order) and replace `DATA = []` with the content of `data.json`.
3. Publish it as an artifact (or open it as a local file). To update, re-run step 1 and replace `DATA`: keep the same artifact.
4. When the human asks for an update, also give them the **% of issues done** in your reply.

## Notes

- Blocking edges are GitHub's native "blocked by" links, the same ones `wayfinder` creates. If the map looks wrong, the blocking links are wrong: fix them on GitHub, not in the map.
- A long horizontal chain = a long critical path. A tall wave = lots of parallel work.
- Use it during phase 4 too: a card that sits in an early wave but can't be tested there is a missing blocking link.
