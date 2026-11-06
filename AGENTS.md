# Working in lean-ui

lean-ui is a small Agent Skill for frontend interaction quality: async states, accessibility basics, practical performance, responsive behavior, and reduced motion. It ships instructions and a teaching example, not a component library, design system, backend, or proven optimization product.

## Layout

- `SKILL.md`: default instructions and selective routing; maximum 600 whitespace-delimited words including frontmatter.
- `references/`: four on-demand guides. Keep conditional detail here rather than expanding the entrypoint.
- `agents/openai.yaml`: Codex discovery/UI metadata.
- `examples/`: self-contained React/Vite comparison, fixture, tests, manifest, and lockfile. The typical version is deliberately flawed.
- `evals/`: evaluation protocol, results template, and dated release evidence.
- `scripts/check.mjs`: dependency-free packaging/link/budget check. It also runs `bash -n scripts/install.sh` (syntax only).
- `scripts/install.sh` and `scripts/install.ps1`: copy this folder into host skill directories. `SKILL.md` must land directly inside the destination, never `lean-ui/lean-ui`.
- `.github/workflows/check.yml`: standalone-repository CI using Node 24.
- `.verification/` and `evals/runs/`: ignored local evidence, never release inputs.

## Setup and commands

Work from the folder containing this file. The skill requires no runtime dependencies. Optional development checks need Node 22.12+ and npm; `npm ci` needs registry access on first install.

```sh
node scripts/check.mjs
bash -n scripts/install.sh
cd examples
npm ci
npm test
npm run build
npm run dev
```

`npm test` runs Vitest/jsdom. `npm run build` runs TypeScript checking and Vite production compilation. There is no configured lint command. Run `git diff --check` for whitespace. `bash -n scripts/install.sh` checks shell syntax only; it does not install the skill and it is not a macOS or Windows execution. Host paths and invocation (`/lean-ui`, Codex `$lean-ui`) are documented in `README.md`.

## Constraints

- Keep this folder independently usable: no imports, paths, scripts, or setup dependencies from its enclosing repository.
- Preserve progressive disclosure. Reference links are relative to the skill folder; do not eagerly load every guide, example, or evaluation document.
- Do not add dependencies, references, components, or abstractions without a demonstrated task-specific gap. Keep example dependencies confined to `examples/` and preserve its lockfile.
- Keep instructions concrete and short. Word/byte counts are proxies, not token counts. Do not claim measured token savings, runtime performance gains, or WCAG compliance.
- Preserve the intentionally incomplete baseline. Fix the lean example when evidence warrants it; do not make the baseline worse to manufacture a difference.
- Do not expand into branding, a design system, backend work, or broad audits. Do not publish, tag, or change remote settings unless asked.
- Treat release evidence as dated observations. Record environment, method, deviations, and untested behavior when making new claims; do not rewrite historical results as new verification.

## Before committing

Run the packaging check for documentation/skill edits and `git diff --check`. For example changes, run its tests and build, then exercise the changed flow in a browser. For instruction/routing changes, use a fresh skill installation and a focused agent task; confirm which references were actually read.

Check that every added relative link survives copying the whole folder, and that `SKILL.md` stays within budget. Review `git diff` and `git status --short` for secrets, generated files, local machine paths, and unrelated edits. Record new release evidence in `evals/release-verification.md` without rewriting earlier results. Never report manual keyboard, zoom, screen-reader, or cross-platform checks as completed based on jsdom or an automated scan alone.
