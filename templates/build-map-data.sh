#!/usr/bin/env bash
# Prints the build map DATA (JSON) for one GitHub repo. REST only (works where GraphQL is blocked).
# Usage: templates/build-map-data.sh owner/repo > data.json
# Needs: gh (logged in), jq.
#
# Status rules (same as the map legend):
#   done     = issue closed
#   progress = open, with an open PR whose body says "Fixes #n" (or Closes / Resolves)
#   blocked  = open, at least one blocker still open (GitHub native "blocked by")
#   hitl     = open, unblocked, label "hitl"
#   ready    = open, every blocker closed
# Areas = labels "area:<name>" if the issue has any, else every label except SKIP and "wayfinder:*".
# The wayfinder map issue itself (label "wayfinder:map") is left out.
set -euo pipefail
REPO="${1:?usage: build-map-data.sh owner/repo}"
SKIP='["hitl","grilling"]'
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT

# Pages one by one (no --paginate: some proxies refuse the repositories/{id} URLs it follows).
pages() { local url=$1 p=1 out; while :; do
  out=$(gh api "$url&per_page=100&page=$p"); [ "$(jq length <<<"$out")" -eq 0 ] && break
  jq -c '.[]' <<<"$out"; p=$((p + 1)); done; }

# 1. Issues (the issues endpoint also returns PRs: drop them).
pages "repos/$REPO/issues?state=all" \
  | jq -s 'map(select(.pull_request | not) | {n: .number, t: .title, state, labels: [.labels[].name]})' > "$tmp/issues.json"

# 2. PRs and the issues they close ("Fixes #12").
pages "repos/$REPO/pulls?state=all" \
  | jq -s 'map({p: .number, s: (if .merged_at then 1 elif .state == "open" then 0 else -1 end), body: (.body // "")})
           | map(. as $pr | [$pr.body | scan("(?i)(?:fix(?:es|ed)?|close[sd]?|resolve[sd]?)\\s+#(\\d+)") | .[0] | tonumber]
               | unique | map({n: ., p: $pr.p, s: $pr.s})) | add // []' > "$tmp/prs.json"

# 3. Native blockers of each open issue (closed issues are done, their blockers don't matter for status
#    but are kept for the graph).
echo '{}' > "$tmp/blockers.json"
for n in $(jq -r '.[].n' "$tmp/issues.json"); do
  b=$(gh api "repos/$REPO/issues/$n/dependencies/blocked_by?per_page=100" --jq '[.[].number]' 2>/dev/null || echo '[]')
  jq --arg n "$n" --argjson b "$b" '. + {($n): $b}' "$tmp/blockers.json" > "$tmp/b.json" && mv "$tmp/b.json" "$tmp/blockers.json"
done

jq -n --slurpfile issues "$tmp/issues.json" --slurpfile prs "$tmp/prs.json" --slurpfile bl "$tmp/blockers.json" --argjson skip "$SKIP" '
  ($issues[0]) as $is | ($prs[0]) as $ps | ($bl[0]) as $bm
  | ($is | map({(.n|tostring): .state}) | add // {}) as $state
  | $is | map(select(.labels | index("wayfinder:map") | not)) | map(
      . as $i
      | ($bm[$i.n|tostring] // [] | map(select($state[tostring] != null))) as $b
      | ($ps | map(select(.n == $i.n)) | map([.p, .s])) as $pr
      | {
          n: $i.n, t: $i.t,
          a: ([$i.labels[] | select(startswith("area:")) | ltrimstr("area:")]
              | if length > 0 then . else [$i.labels[] | select(startswith("wayfinder:") | not)] - $skip end),
          h: ($i.labels | any(. == "hitl")),
          g: ($i.labels | any(. == "grilling" or . == "wayfinder:grilling")),
          b: $b, pr: $pr,
          st: (
            if $i.state == "closed" then "done"
            elif ($pr | any(.[1] == 0)) then "progress"
            elif ($b | any($state[tostring] == "open")) then "blocked"
            elif ($i.labels | any(. == "hitl")) then "hitl"
            else "ready" end
          )
        })
'
