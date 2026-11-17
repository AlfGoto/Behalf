# Issue trackers

behalf doesn't need GitHub Issues. Linear, Jira, Notion and other trackers with a good connection to Claude (MCP or API) work too. The method only needs four things from a tracker.

## What the tracker must do

| Need | Why | GitHub Issues | Others |
|---|---|---|---|
| **Issues** that stand alone | A fresh agent reads one issue + the docs | ✓ | ✓ |
| **Native blocking links** ("blocked by") | The testability rule, the launcher and the build map all read them | ✓ "blocked by" | Linear "blocked by", Jira "is blocked by" link, Notion: a relation property |
| **Labels** (area, `hitl`, `grilling`) | The launcher skips human work; the map groups by area | ✓ | Labels / tags / a select property |
| **A way to start the executor** | Turns a ready issue into a PR | `@claude` comment on the issue | See below |

Prefer native links over a "Blocked by: #12" line in the body: the tracker shows them, and agents can't misread them.

## Starting the executor with another tracker

The executor and reviewer stay on GitHub, next to the code (Actions on the repo). Only the issues move. Pick one way to start work from a tracker issue:

- **The launcher bridges it**: it reads the tracker (through its MCP or API), and for each ready issue opens a GitHub issue that links back and contains `@claude do this` (or comments it on an existing mirror). The PR says `Fixes #n` for the GitHub issue and links the tracker issue.
- **The tracker's own GitHub integration**: if it creates or syncs GitHub issues, the launcher only has to comment `@claude do this` on the synced issue.
- **The tracker's own agent integration**, if it has one that can run Claude Code on the repo: then follow the same rules (draft PR, assigned to the human, `Fixes`/link, How to test first).

Whatever the bridge, keep the rest the same: one issue = one draft PR, review loop on GitHub, the human merges.

## What changes per tracker

- **`wayfinder`**: run `setup-matt-pocock-skills` once to pick the tracker; it then creates the map and the blocking links there.
- **Launcher** ([agents/launcher.md](agents/launcher.md)): same filter (open, all blockers done, no open PR, not launched, not `hitl` / grilling), read from the tracker instead of the GitHub API.
- **Build map** ([agents/build-map.md](agents/build-map.md)): `templates/build-map-data.sh` reads GitHub. For another tracker, produce the same JSON (`n, t, st, a, h, g, b, pr`) from its API and paste it into the template. The map itself doesn't change.
- **Statuses**: map the tracker's states to done / progress / blocked / hitl / ready, using the same rules.
