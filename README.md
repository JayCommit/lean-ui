# lean-ui

A small Agent Skill for frontend interaction quality: async states, basic accessibility, practical performance, responsive behavior, and reduced motion. Includes React/Next.js guidance; the principles apply elsewhere. No component library, branding/design system, backend work, or required companion skills.

## Install

Mac is the primary command form. Windows is second. Copy **this** folder — the one that contains `SKILL.md` — so the destination is `.../lean-ui/SKILL.md`. Never create `lean-ui/lean-ui/SKILL.md`. Do not copy `node_modules`, `dist`, `.git`, or local evaluation runs. If a destination already exists, stop and review it before replacing it.

These commands place files. They do not prove a host loaded the skill. Start a fresh session after copying. `bash -n scripts/install.sh` checks shell syntax only; it does not run the installer and it is not a macOS or Windows execution.

The installers are [scripts/install.sh](scripts/install.sh) and [scripts/install.ps1](scripts/install.ps1). `--host` is `grok`, `grok-bot`, `cursor`, `openai`, `antigravity`, `claude`, or `all` (default). `--scope` is `user` (default) or `project`. The script copies the folder that contains it, not whatever directory the shell happens to be in. Project scope writes under the current directory. User scope writes under the home directory.

### 1. Grok

- Project: `.grok/skills/lean-ui/`
- User: `~/.grok/skills/lean-ui/`
- Grok also reads `~/.agents/skills/lean-ui/` (the OpenAI user path below). Installing `--host grok` does not also copy that path; `--host openai` or `--host all` does.
- Invoke: `/lean-ui`

### 2. Grok Bot

Same folder on the bot computer: `~/.grok/skills/lean-ui/`. There is no second skill format. `--host grok-bot` always uses that user path; `--scope project` is an error for that host alone. Invoke `/lean-ui`.

Paste this to the bot:

```text
Clone https://github.com/JayCommit/lean-ui and check out tag v0.0.2. Copy that repository folder to ~/.grok/skills/lean-ui so ~/.grok/skills/lean-ui/SKILL.md exists. Do not create ~/.grok/skills/lean-ui/lean-ui/SKILL.md. Skip .git, node_modules, and dist. On macOS, from the checkout, run: bash scripts/install.sh --host grok-bot --scope user
(cp -R into $HOME/.grok/skills/lean-ui). On Windows PowerShell, run: powershell -NoProfile -ExecutionPolicy Bypass -File scripts\install.ps1 --host grok-bot --scope user
(Copy-Item into $env:USERPROFILE\.grok\skills\lean-ui). Do not convert the skill into another format. Invoke /lean-ui.
```

### 3. Cursor

- Project: `.cursor/skills/lean-ui/`
- User: `~/.cursor/skills/lean-ui/`
- The frontmatter `name` is `lean-ui`, matching the folder. Do not rename one without the other.
- Invoke: `/lean-ui`

### 4. OpenAI / ChatGPT app

- Project: `.agents/skills/lean-ui/`
- User: `~/.agents/skills/lean-ui/`
- Codex invoke: `$lean-ui`
- ChatGPT: zip this folder, then Plugins → Skills → Add → Upload. `SKILL.md` should be at the archive root, or one `lean-ui/` directory down. Do not zip a parent in a way that produces `lean-ui/lean-ui/SKILL.md`.
- [agents/openai.yaml](agents/openai.yaml) is the existing Codex UI metadata. Keep that file; do not invent a second skill format.

User and project Codex locations are also described in [OpenAI's skill guide](https://learn.chatgpt.com/docs/build-skills).

### 5. Antigravity

- Project: `.agents/skills/lean-ui/`, one level deep. `SKILL.md` is directly inside that folder. Do not add another directory between `skills` and `SKILL.md`.
- User: `~/.gemini/config/skills/lean-ui/`
- CLI: `~/.gemini/antigravity-cli/skills/lean-ui/`
- `description` is required in `SKILL.md` and is already set.
- Invoke: `/lean-ui`

### 6. Claude

- Project: `.claude/skills/lean-ui/`
- User: `~/.claude/skills/lean-ui/`
- Invoke: `/lean-ui`

### macOS

From this folder (the directory that contains `SKILL.md`):

```sh
bash scripts/install.sh
bash scripts/install.sh --host cursor --scope project
```

Manual copy, if you are not using the script. `skill` must be this folder. `cp -R` onto a path that does not exist places `SKILL.md` directly inside the destination. If the destination already exists, `cp -R` of a directory into it nests another folder, so these commands stop instead.

```sh
skill=$(pwd)
copy_skill() {
  destination=$1
  if [ -e "$destination" ]; then
    echo "lean-ui already exists at $destination; review it first"
    exit 1
  fi
  mkdir -p "$(dirname "$destination")"
  cp -R "$skill" "$destination"
  rm -rf "$destination/node_modules" "$destination/examples/node_modules" \
    "$destination/dist" "$destination/examples/dist" "$destination/coverage" \
    "$destination/.git" "$destination/.verification" "$destination/evals/runs"
  if [ ! -f "$destination/SKILL.md" ] || [ -f "$destination/lean-ui/SKILL.md" ]; then
    echo "expected $destination/SKILL.md without a nested lean-ui folder"
    exit 1
  fi
}

# user, in host order: Grok and Grok Bot, Cursor, OpenAI, Antigravity app, Antigravity CLI, Claude
copy_skill "$HOME/.grok/skills/lean-ui"
copy_skill "$HOME/.cursor/skills/lean-ui"
copy_skill "$HOME/.agents/skills/lean-ui"
copy_skill "$HOME/.gemini/config/skills/lean-ui"
copy_skill "$HOME/.gemini/antigravity-cli/skills/lean-ui"
copy_skill "$HOME/.claude/skills/lean-ui"

# project: set project to the target project root, not to a destination that already exists
# copy_skill "$project/.grok/skills/lean-ui"
# copy_skill "$project/.cursor/skills/lean-ui"
# copy_skill "$project/.agents/skills/lean-ui"
# copy_skill "$project/.claude/skills/lean-ui"
```

ChatGPT zip from this folder:

```sh
zip -r "$HOME/lean-ui-skill.zip" . \
  -x '.git/*' -x '.git/**' -x '*/node_modules/*' -x '*/dist/*' \
  -x '.verification/*' -x 'evals/runs/*'
```

### Windows

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 --host cursor --scope project
```

Manual copy from this folder. `Copy-Item` of the folder onto a new path keeps `SKILL.md` directly inside that path. If the destination already exists, copying the folder into it creates `lean-ui\lean-ui`; these commands stop instead.

```powershell
$skill = (Get-Location).Path
function Copy-LeanUiSkill {
  param([string]$Destination)
  if (Test-Path -LiteralPath $Destination) {
    throw "lean-ui already exists at $Destination; review it first"
  }
  $parent = Split-Path -Parent $Destination
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  Copy-Item -LiteralPath $skill -Destination $Destination -Recurse -Force
  foreach ($relative in @(
    'node_modules', 'examples\node_modules', 'dist', 'examples\dist',
    'coverage', '.git', '.verification', 'evals\runs'
  )) {
    $path = Join-Path $Destination $relative
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Recurse -Force }
  }
  $skillFile = Join-Path $Destination 'SKILL.md'
  $nested = Join-Path $Destination 'lean-ui\SKILL.md'
  if (-not (Test-Path -LiteralPath $skillFile) -or (Test-Path -LiteralPath $nested)) {
    throw "expected $skillFile without a nested lean-ui folder"
  }
}

Copy-LeanUiSkill (Join-Path $env:USERPROFILE '.grok\skills\lean-ui')
Copy-LeanUiSkill (Join-Path $env:USERPROFILE '.cursor\skills\lean-ui')
Copy-LeanUiSkill (Join-Path $env:USERPROFILE '.agents\skills\lean-ui')
Copy-LeanUiSkill (Join-Path $env:USERPROFILE '.gemini\config\skills\lean-ui')
Copy-LeanUiSkill (Join-Path $env:USERPROFILE '.gemini\antigravity-cli\skills\lean-ui')
Copy-LeanUiSkill (Join-Path $env:USERPROFILE '.claude\skills\lean-ui')

# project: set $project to the target project root first
# Copy-LeanUiSkill (Join-Path $project '.grok\skills\lean-ui')
# Copy-LeanUiSkill (Join-Path $project '.cursor\skills\lean-ui')
# Copy-LeanUiSkill (Join-Path $project '.agents\skills\lean-ui')
# Copy-LeanUiSkill (Join-Path $project '.claude\skills\lean-ui')
```

ChatGPT zip from this folder. Remove `examples\node_modules` and `examples\dist` first if they exist; `Compress-Archive` would otherwise include them.

```powershell
$zip = Join-Path $env:USERPROFILE 'lean-ui-skill.zip'
if (Test-Path -LiteralPath $zip) { Remove-Item -LiteralPath $zip -Force }
Compress-Archive -Path (Get-ChildItem -Force | Where-Object {
  $_.Name -notin @('.git', 'node_modules', 'dist', 'coverage', '.verification')
}) -DestinationPath $zip
```


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
- Install commands copy files into the folders above. They do not prove the host discovered the skill. `bash -n scripts/install.sh` checks shell syntax only; it is not a macOS or Windows execution.

Licensed under [MIT](LICENSE).
