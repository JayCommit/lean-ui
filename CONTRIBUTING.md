# Contributing

Work from this repository root. The skill is Markdown and YAML and has no runtime dependencies. Optional checks need Node.js 22.12+ and npm. The first `npm ci` needs registry access.

```sh
node scripts/check.mjs
git diff --check
cd examples
npm ci
npm test
npm run build
npm run dev
```

`npm test` runs Vitest in jsdom. It does not prove keyboard, zoom, reflow, or screen-reader behavior. There is no separate lint command. `npm run dev` is a local Vite server; stop it when you are done.

Keep `SKILL.md` within 600 whitespace-delimited words. Do not add skill dependencies. Keep example dependencies inside `examples/` and preserve its lockfile. Leave `examples/TypicalSearch.tsx` intentionally flawed.

Do not claim WCAG compliance, measured token savings, or a general quality improvement. Report security issues privately; see [SECURITY.md](SECURITY.md). Other feedback can use [GitHub issues](https://github.com/JayCommit/lean-ui/issues).
