# Driving the agent from the PR

**The PR is the human's control panel.** Anything the human wants changed, asked, or explained, they say right there, and an agent picks it up. No local checkout, no copy-pasting into a chat.

## Ways to start an agent from a PR

| The human writes… | Where | What happens |
|---|---|---|
| `@claude <request>` | PR conversation | The executor works on the PR branch and pushes |
| `@claude <request>` | An inline comment on a line of the diff | Same, with that line as context |
| A review with `@claude` in its body | "Review changes" | The executor handles the whole review |
| **A plain reply, no `@claude`** | Under a Claude comment, or in a thread Claude started | Treated as a reply to Claude: the executor answers or acts |
| `@claude fix conflicts` | PR conversation | Merges main in and fixes the conflicts ([conflict-fixer.md](conflict-fixer.md)) |
| `/preview` (if set up) | PR conversation | Starts a live test environment for this PR |

The plain reply matters: talking to the agent feels like talking to a colleague, not typing commands.

## How it's wired (claude.yml)

- Triggers: `issue_comment`, `pull_request_review_comment`, `pull_request_review`, `issues: opened`.
- A small `reply` job checks if a human comment without `@claude` answers `claude[bot]` (last earlier comment in the conversation, or the parent of an inline reply). If yes, it passes the comment's first word as the trigger phrase.
- `/preview` comments are never treated as replies.
- **One queue per issue/PR**, job-level concurrency, no cancel: requests run one after the other and never replace each other.
- Before working, the PR goes back to **draft** (agent working). If the agent ends without pushing (it only answered), the PR goes back to **ready** (your turn). If it pushed, the review runs and sets the status.
- When the agent pushes, it also updates the PR's "How to test".

## Good habits

- Ask for one thing per comment: it maps to one push and one review.
- Disagree in the thread: the agent may also disagree with a review comment and explain instead of changing the code.
- If the fix loop stopped after 3 rounds, read the last review, then reply with the decision.
