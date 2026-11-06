#!/usr/bin/env bash
# Copy this lean-ui folder so SKILL.md is a direct child of each destination.
# Never produce lean-ui/lean-ui. bash -n checks syntax only; it does not install.
set -euo pipefail

SOURCE=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
HOST=all
SCOPE=user

usage() {
  cat <<'EOF'
Usage: bash scripts/install.sh [--host HOST] [--scope SCOPE]

Copy the lean-ui folder that contains this script. SKILL.md is placed
directly inside the destination skill folder, never lean-ui/lean-ui.

--host   grok | grok-bot | cursor | openai | antigravity | claude | all
         (default: all)
--scope  user | project
         (default: user)

User paths are under $HOME. Project paths are under the current directory.
grok-bot is only the user folder on the bot computer: $HOME/.grok/skills/lean-ui.
--host grok-bot --scope project is an error.
--host all --scope project does not write that bot path.

If a destination already exists, nothing is copied and the script exits 1.
EOF
}

die() {
  printf '%s\n' "$1" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      [[ $# -ge 2 ]] || die "--host needs a value"
      HOST=$2
      shift 2
      ;;
    --host=*)
      HOST=${1#--host=}
      [[ -n "$HOST" ]] || die "--host needs a value"
      shift
      ;;
    --scope)
      [[ $# -ge 2 ]] || die "--scope needs a value"
      SCOPE=$2
      shift 2
      ;;
    --scope=*)
      SCOPE=${1#--scope=}
      [[ -n "$SCOPE" ]] || die "--scope needs a value"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

case "$HOST" in
  grok|grok-bot|cursor|openai|antigravity|claude|all) ;;
  *) die "unknown --host: $HOST" ;;
esac

case "$SCOPE" in
  user|project) ;;
  *) die "unknown --scope: $SCOPE" ;;
esac

if [[ ! -f "$SOURCE/SKILL.md" ]]; then
  die "SKILL.md not found in $SOURCE"
fi

if [[ "$HOST" == "grok-bot" && "$SCOPE" == "project" ]]; then
  die "grok-bot installs only to \$HOME/.grok/skills/lean-ui on the bot computer; re-run with --scope user"
fi

needs_home=0
if [[ "$SCOPE" == "user" ]]; then
  needs_home=1
fi
if [[ "$HOST" == "grok-bot" ]]; then
  needs_home=1
fi
if [[ "$needs_home" -eq 1 && -z "${HOME:-}" ]]; then
  die "HOME is not set"
fi

dests=()
add_dest() {
  local dest=$1
  local existing
  if [[ ${#dests[@]} -gt 0 ]]; then
    for existing in "${dests[@]}"; do
      if [[ "$existing" == "$dest" ]]; then
        return 0
      fi
    done
  fi
  dests+=("$dest")
}

if [[ "$HOST" == "all" || "$HOST" == "grok" ]]; then
  if [[ "$SCOPE" == "user" ]]; then
    add_dest "$HOME/.grok/skills/lean-ui"
  else
    add_dest "$PWD/.grok/skills/lean-ui"
  fi
fi

if [[ "$HOST" == "grok-bot" || ( "$HOST" == "all" && "$SCOPE" == "user" ) ]]; then
  add_dest "$HOME/.grok/skills/lean-ui"
fi

if [[ "$HOST" == "all" || "$HOST" == "cursor" ]]; then
  if [[ "$SCOPE" == "user" ]]; then
    add_dest "$HOME/.cursor/skills/lean-ui"
  else
    add_dest "$PWD/.cursor/skills/lean-ui"
  fi
fi

if [[ "$HOST" == "all" || "$HOST" == "openai" ]]; then
  if [[ "$SCOPE" == "user" ]]; then
    add_dest "$HOME/.agents/skills/lean-ui"
  else
    add_dest "$PWD/.agents/skills/lean-ui"
  fi
fi

if [[ "$HOST" == "all" || "$HOST" == "antigravity" ]]; then
  if [[ "$SCOPE" == "user" ]]; then
    add_dest "$HOME/.gemini/config/skills/lean-ui"
    add_dest "$HOME/.gemini/antigravity-cli/skills/lean-ui"
  else
    add_dest "$PWD/.agents/skills/lean-ui"
  fi
fi

if [[ "$HOST" == "all" || "$HOST" == "claude" ]]; then
  if [[ "$SCOPE" == "user" ]]; then
    add_dest "$HOME/.claude/skills/lean-ui"
  else
    add_dest "$PWD/.claude/skills/lean-ui"
  fi
fi

if [[ ${#dests[@]} -eq 0 ]]; then
  die "no destinations selected"
fi

blocked=0
for dest in "${dests[@]}"; do
  if [[ -z "$dest" || "$dest" == "/" || "$dest" == "$PWD" || "$dest" == "$SOURCE" ]]; then
    die "refusing unsafe destination: $dest"
  fi
  if [[ -n "${HOME:-}" && "$dest" == "$HOME" ]]; then
    die "refusing unsafe destination: $dest"
  fi
  if [[ -e "$dest" ]]; then
    printf 'lean-ui already exists at %s; review it first\n' "$dest" >&2
    blocked=1
  fi
done
if [[ "$blocked" -ne 0 ]]; then
  exit 1
fi

stage=
cleanup() {
  if [[ -n "${stage}" && -d "${stage}" ]]; then
    rm -rf "$stage"
  fi
}
trap cleanup EXIT

copy_skill() {
  local dest=$1
  local copy="$stage/lean-ui"
  if [[ "$stage" == "$SOURCE" || "$stage" == "$SOURCE"/* ]]; then
    die "refusing to stage the copy inside the source tree"
  fi
  cp -R "$SOURCE" "$copy"
  rm -rf \
    "$copy/node_modules" \
    "$copy/examples/node_modules" \
    "$copy/dist" \
    "$copy/examples/dist" \
    "$copy/coverage" \
    "$copy/examples/coverage" \
    "$copy/.git" \
    "$copy/.verification" \
    "$copy/evals/runs"
  rm -f "$copy/.env" "$copy/examples/.env"
  local extra
  for extra in "$copy"/*.tsbuildinfo "$copy"/examples/*.tsbuildinfo; do
    if [[ -f "$extra" ]]; then
      rm -f "$extra"
    fi
  done
  if [[ ! -f "$copy/SKILL.md" || -f "$copy/lean-ui/SKILL.md" ]]; then
    die "staged copy is not a single skill folder with SKILL.md directly inside"
  fi
  mkdir -p "$(dirname "$dest")"
  mv "$copy" "$dest"
  if [[ ! -f "$dest/SKILL.md" || -f "$dest/lean-ui/SKILL.md" ]]; then
    die "install failed: expected $dest/SKILL.md without a nested lean-ui folder"
  fi
  printf 'installed %s\n' "$dest"
}

for dest in "${dests[@]}"; do
  stage=$(mktemp -d)
  if [[ "$stage" == "$SOURCE" || "$stage" == "$SOURCE"/* ]]; then
    die "refusing to stage the copy inside the source tree"
  fi
  copy_skill "$dest"
  rm -rf "$stage"
  stage=
done
trap - EXIT
