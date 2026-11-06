# Contributing

Work from this repository root. The skill is Markdown and YAML and has no runtime dependencies. Optional checks need Node.js 22.12+ and npm. The first `npm ci` needs registry access.

```sh
node scripts/check.mjs
bash -n scripts/install.sh
git diff --check
cd examples
npm ci
npm test
npm run build
npm run dev
```

`npm test` runs Vitest in jsdom. It does not prove keyboard, zoom, reflow, or screen-reader behavior. There is no separate lint command. `npm run dev` is a local Vite server; stop it when you are done.

`node scripts/check.mjs` also runs `bash -n scripts/install.sh`. That is a syntax check only. It does not install the skill and it is not a macOS or Windows run. [scripts/install.ps1](scripts/install.ps1) is the Windows installer; do not claim it ran unless it was actually started. Host paths and invocation are in [README.md](README.md). The installers copy this folder so `SKILL.md` is directly inside the destination skill folder.

Keep `SKILL.md` within 600 whitespace-delimited words. Do not add skill dependencies. Keep example dependencies inside `examples/` and preserve its lockfile. Leave `examples/TypicalSearch.tsx` intentionally flawed.

Do not claim WCAG compliance, measured token savings, or a general quality improvement. Report security issues privately; see [SECURITY.md](SECURITY.md). Other feedback can use [GitHub issues](https://github.com/JayCommit/lean-ui/issues).
