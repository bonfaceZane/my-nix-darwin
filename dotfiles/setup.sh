#!/usr/bin/env bash
# Wire the OpenCode configuration globally and per-project.
#
#   global: ~/.config/opencode -> dotfiles/opencode (skipped when Home Manager
#           already manages that path, which is the normal case here)
#   local:  <project>/opencode.json <- dotfiles/opencode/opencode.local.json
#
# The local template only overrides the model and adds the project's AGENTS.md;
# OpenCode merges it over the global config, so skills/LSP/plugin are inherited.
#
# Usage:
#   dotfiles/setup.sh global
#   dotfiles/setup.sh local <project> [project ...]
#   dotfiles/setup.sh all <project> [project ...]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_SRC="$SCRIPT_DIR/opencode"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
GLOBAL_DIR="$CONFIG_HOME/opencode"

link_global() {
  if [ -L "$GLOBAL_DIR" ]; then
    echo "global: $GLOBAL_DIR is already managed (symlink); skipping"
    return 0
  fi
  mkdir -p "$GLOBAL_DIR/skills"
  ln -sfn "$OPENCODE_SRC/opencode.json" "$GLOBAL_DIR/opencode.json"
  for skill in repo-map ast-outline token-discipline; do
    ln -sfn "$OPENCODE_SRC/skills/$skill" "$GLOBAL_DIR/skills/$skill"
  done
  echo "global: linked $GLOBAL_DIR/opencode.json and skills/"
}

link_local() {
  local project="$1"
  if [ ! -d "$project" ]; then
    echo "local: skipping '$project' (not a directory)" >&2
    return 1
  fi
  if [ -e "$project/opencode.json" ]; then
    echo "local: keeping existing $project/opencode.json"
    return 0
  fi
  cp "$OPENCODE_SRC/opencode.local.json" "$project/opencode.json"
  echo "local: wrote $project/opencode.json"
}

action="${1:-all}"
shift || true

case "$action" in
  global) link_global ;;
  local) for project in "$@"; do link_local "$project"; done ;;
  all)
    link_global
    for project in "$@"; do link_local "$project"; done
    ;;
  *)
    echo "usage: $0 {global|local|all} [project ...]" >&2
    exit 2
    ;;
esac
