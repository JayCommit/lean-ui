# lean-ui

A small Agent Skill for frontend interaction quality: async states, basic accessibility, practical performance, responsive behavior, and reduced motion. Includes React/Next.js guidance; the principles apply elsewhere. No component library, branding/design system, backend work, or required companion skills.

## Install in Codex

Start in a clean checkout or extracted copy of this folder, with `SKILL.md` at its root. **Copy the whole folder**, including `references`, `agents`, and `examples`. Do not copy `node_modules`, `dist`, or local evaluation runs. These commands stop if an installation already exists; review it before replacing it.

PowerShell:

```powershell
$destination = Join-Path $HOME '.agents/skills/lean-ui'
if (Test-Path -LiteralPath $destination) { throw 'lean-ui already exists; review it first' }
New-Item -ItemType Directory -Force (Split-Path $destination) | Out-Null
Copy-Item -LiteralPath (Get-Location).Path -Destination $destination -Recurse
```

macOS/Linux shell:

```sh
destination="$HOME/.agents/skills/lean-ui"
if [ -e "$destination" ]; then echo 'lean-ui already exists; review it first'; exit 1; fi
mkdir -p "$HOME/.agents/skills"
cp -R . "$destination"
```

Start a fresh Codex chat and invoke: `Use $lean-ui to add search with loading, empty, error, and retry behavior.` If it does not appear, restart Codex and check that the path ends in `lean-ui/SKILL.md`. User and project install locations are documented in [OpenAI's skill guide](https://learn.chatgpt.com/docs/build-skills). For project-only use, copy to that project's `.agents/skills/lean-ui` instead. Other agents need support for the `SKILL.md` format; their discovery paths are not verified here.

## Run checks and example

The skill itself is Markdown/YAML: no runtime packages, network calls, or parent-repository dependencies. The optional example/checks require Node 22.12+ and npm; the example's first install needs registry access.

From the copied `lean-ui` folder:

```sh
node scripts/check.mjs
cd examples
npm ci
npm test
npm run build
npm run dev
```

Open Vite's local URL. Try `focus`, `nothing`, `error`, and `slow`. Compare keyboard submission, progress feedback, empty/error explanations, recovery, and rapid resubmission. The intentionally flawed baseline is teaching material; do not ship it. See [example details and manual checks](examples/README.md).

## Cost and evidence

[SKILL.md](SKILL.md) contains the default guidance; four linked references supply detail on demand. Reference loading is an agent decision, not an enforced token limit. `node scripts/check.mjs` checks local Markdown targets and a 600-word entrypoint ceiling, printing words and UTF-8 bytes. These are budget proxies, **not exact token measurements**.

To evaluate agent output, follow [the paired-task protocol](evals/README.md) in fresh contexts, then record results using [the template](evals/results-template.md). [Release verification](evals/release-verification.md) distinguishes automated checks, visual inspection, and untested behavior. Agent-output improvements are not yet established by a benchmark; a small release pilot cannot demonstrate general effectiveness.

## Known limitations

- Browser, zoom, keyboard, and screen-reader checks are manual adoption steps; `npm test` uses jsdom and cannot verify them. Release-time browser automation covers only the recorded environment.
- No full WCAG compliance claim. Labels and roles do not prove usable announcements, contrast, or assistive-technology support. Screen-reader testing remains unperformed unless explicitly recorded.
- No measured runtime performance gains or guaranteed token savings. Advice and reference routing depend on the agent following instructions.
- Example behavior covers a local search fixture, not real API integration, authentication, or production failure modes. Next.js and other frameworks have no runnable example here.
- The CI workflow assumes this folder is the repository root. GitHub-hosted CI and other operating systems require their own run; local checks alone do not verify those environments.

Licensed under [MIT](LICENSE).
