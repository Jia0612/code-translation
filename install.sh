#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="code-translation"
REPO_URL="https://github.com/Jia0612/code-translation.git"
PLATFORM="${1:-agent}"

case "$PLATFORM" in
  codex) TARGET="${CODEX_HOME:-$HOME/.codex}/skills" ;;
  claude) TARGET="$HOME/.claude/skills" ;;
  gemini|agent|agents) TARGET="$HOME/.agents/skills" ;;
  cursor) TARGET="$HOME/.cursor/skills" ;;
  copilot|vscode) TARGET="$HOME/.copilot/skills" ;;
  opencode) TARGET="$HOME/.config/opencode/skills" ;;
  *) printf 'Unsupported platform: %s\n' "$PLATFORM" >&2; exit 2 ;;
esac

mkdir -p "$TARGET"
DEST="$TARGET/$SKILL_NAME"
if [[ -d "$DEST/.git" ]]; then git -C "$DEST" pull --ff-only
elif [[ -e "$DEST" ]]; then printf 'Destination exists: %s\n' "$DEST" >&2; exit 1
else git clone --depth 1 "$REPO_URL" "$DEST"; fi
printf 'Installed %s at %s. Restart the agent to discover it.\n' "$SKILL_NAME" "$DEST"
