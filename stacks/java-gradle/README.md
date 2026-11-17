# Java / Gradle stack (e.g. a game server plugin, a backend service)

Use the files in `stacks/common/`, plus these.

## Setup step in `claude.yml`

Replace the `STACK SETUP` comment with:

```yaml
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 21
      - uses: gradle/actions/setup-gradle@v4
```

Set the Java version your project needs.

## `env:` values in `claude.yml`

```yaml
  STACK_TOOLS: "Bash(./gradlew:*),Bash(gradle:*),Bash(java:*),Bash(javap:*),Bash(jar:*)"
  TEST_HINT: "Run ./gradlew test before pushing. Never list ./gradlew test as a How to test step: CI runs it."
```

## Agent-written PRs and Gradle

`claude-code-action` blocks build commands on PRs whose author it can't verify as trusted, and bots can't be verified. If the executor can't run `./gradlew` on its own PRs, add this to the action's `with:` in `claude.yml`, so only PRs written by `claude[bot]` are trusted and all others stay restricted:

```yaml
          restrict_untrusted_prs: ${{ (github.event.issue.user.login || github.event.pull_request.user.login) == 'claude[bot]' && 'false' || 'true' }}
```

**This turns off a safety check, so use it only if you need it.**
- Try without it first. Add it only if the executor really can't build or test its own PRs.
- It trusts PRs written by `claude[bot]` only. Every other PR stays restricted.
- What gets into those PRs comes from issue and PR text, so keep the safeguards in "Security" (`practices/3-agent-pipeline.md`): only people with write access trigger the agent, protected `main`, no merge by the agent.

## CI

- `test.yml`: `./gradlew build` (compiles + tests) on every PR that touches code or build files.

## Preview for something that isn't a website

Working example: `.github/workflows/preview-game-server.yml` (a Paper server for a Minecraft plugin, exposed with a playit.gg tunnel).

When the human must test in an app, a game or a server, a `/preview` workflow can build the PR and start it somewhere reachable: comment `/preview` on the PR → build → start the server → expose it (e.g. through a game or TCP tunnel service) → post the address as a comment → stop after N minutes without users, with a hard cap.

Rules for that workflow:
- Only PRs from this repo (no forks) and only commenters with write access: the tunnel secret sits next to code from the PR.
- One slot: the latest `/preview` cancels the previous one.
- Keep tokens and passwords out of the server's environment.
- Post a comment when it starts (address) and when it stops.
- Make `/preview` the first step of the PR template's How to test.
