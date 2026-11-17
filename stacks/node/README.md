# Node / TypeScript stack (e.g. a Next.js front + a Node back)

Use the files in `stacks/common/`, plus these.

## Setup step in `claude.yml`

Replace the `STACK SETUP` comment with:

```yaml
      - uses: actions/setup-node@v4
        with:
          node-version: 22
```

## `env:` values in `claude.yml`

```yaml
  STACK_TOOLS: "Bash(npm ci:*),Bash(npm install:*),Bash(npm i:*),Bash(npm run:*),Bash(npm test:*),Bash(npm --prefix:*),Bash(npx tsc:*)"
  TEST_HINT: "Run the tests only for the folder you changed before pushing: back/ → cd back && npm test; front/ → cd front && npm run lint && npm run build && npm test."
```

Add tool rules for your own tools (e.g. `Bash(npx prisma:*)`, `Bash(npx jest:*)`). Anything not listed is refused.

## CI

- `test-back.yml`: **have this one.** Backend tests on every PR that touches `back/`.
- `test-front.yml`: optional. Lint + build (+ tests if any) on PRs that touch `front/`.
- Rename the folders to match your repo. One workflow per folder, each with its own `paths:` filter.

## Tips

- Libraries or CLIs your users install: add a real build test (install it in a fresh project and build), so fixed bugs stay fixed.
- Monorepo without a workspaces tool: one `package-lock.json` per folder, `cache-dependency-path` pointing at it.
- Preview: most hosts (Vercel, Netlify, Cloudflare) give each PR its own preview URL. Put "open the preview URL" as the first step of How to test.
