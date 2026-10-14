#!/usr/bin/env bash
set -euo pipefail

CODE_ROOT="${1:?Usage: project.sh CODE_ROOT INVOCATION_DIRECTORY [PROJECT]}"
INVOKED_FROM="${2:?Missing invocation directory}"
PROJECT="${3:-}"

for executable in herdr node; do
  if ! command -v "$executable" >/dev/null 2>&1; then
    echo "Missing required tool: $executable" >&2
    exit 1
  fi
done

CODE_ROOT="$(cd "$CODE_ROOT" && pwd -P)"
if [[ -n "$PROJECT" ]]; then
  # Explicit relative path, e.g. OrgA/ProjectC (or an absolute path from pick).
  if [[ "$PROJECT" == /* ]]; then
    TARGET="$PROJECT"
  else
    TARGET="$CODE_ROOT/$PROJECT"
  fi
else
  TARGET="$INVOKED_FROM"
fi

[[ -d "$TARGET" ]] || { echo "Directory not found: $TARGET" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd -P)"

case "$TARGET" in
  "$CODE_ROOT"/*) ;;
  "$CODE_ROOT") echo "Run from a project directory or use just pick" >&2; exit 1 ;;
  *) echo "Project must be inside $CODE_ROOT" >&2; exit 1 ;;
esac

# Explicit selections are exact project roots, even when nested inside
# an organisation directory that is itself a Git repository.
if [[ -n "$PROJECT" ]]; then
  PROJECT_DIR="$TARGET"
else
  # Find the closest .git marker by walking upwards. Unlike
  # `git rev-parse --show-toplevel`, this handles nested repositories
  # without accidentally choosing an organisation's Git root.
  cursor="$TARGET"
  PROJECT_DIR=""
  while [[ "$cursor" != "$CODE_ROOT" ]]; do
    if [[ -d "$cursor/.git" || -f "$cursor/.git" ]]; then
      PROJECT_DIR="$cursor"
      break
    fi
    cursor="$(dirname "$cursor")"
  done
  if [[ -z "$PROJECT_DIR" ]]; then
    # Backwards-compatible fallback for projects without Git.
    relative="${TARGET#"$CODE_ROOT"/}"
    PROJECT_DIR="$CODE_ROOT/${relative%%/*}"
  fi
fi

case "$PROJECT_DIR" in
  "$CODE_ROOT"/*) ;;
  *) echo "Git root must be inside $CODE_ROOT: $PROJECT_DIR" >&2; exit 1 ;;
esac
PROJECT_NAME="${PROJECT_DIR#"$CODE_ROOT"/}"

# Read and validate the real JSON response before creating anything.
WORKSPACES="$(herdr workspace list)"

# WorkspaceInfo does not contain cwd. Inspect each workspace's panes instead.
find_workspace() {
  local target="$1"
  printf '%s' "$WORKSPACES" | node -e '
    const fs = require("node:fs");
    const path = require("node:path");
    const cp = require("node:child_process");
    const target = fs.realpathSync(process.argv[1]);
    const data = JSON.parse(fs.readFileSync(0, "utf8"));
    const items = data?.result?.workspaces;
    if (!Array.isArray(items)) {
      console.error("Unexpected Herdr workspace list response");
      process.exit(2);
    }
    for (const w of items) {
      const id = w.workspace_id;
      if (typeof id !== "string") continue;
      const result = JSON.parse(cp.execFileSync("herdr", ["pane", "list", "--workspace", id], {encoding:"utf8"}));
      const panes = result?.result?.panes;
      if (!Array.isArray(panes)) {
        console.error(`Unexpected pane list for workspace ${id}`);
        process.exit(2);
      }
      if (panes.some(p => {
        const cwd = p.cwd;
        if (typeof cwd !== "string") return false;
        try { return fs.realpathSync(cwd) === target; } catch { return false; }
      })) {
        process.stdout.write(id);
        break;
      }
    }
  ' "$target"
}

json_field() {
  local field="$1"
  node -e '
    const fs = require("node:fs");
    const data = JSON.parse(fs.readFileSync(0, "utf8"));
    const value = process.argv[1].split(".").reduce((obj, key) => obj?.[key], data);
    if (typeof value !== "string") {
      console.error(`Missing JSON field: ${process.argv[1]}`);
      process.exit(1);
    }
    process.stdout.write(value);
  ' "$field"
}

# One Home workspace per macOS home directory.
home_id="$(find_workspace "$HOME")"
if [[ -z "$home_id" ]]; then
  echo "Creating home-directory workspace"
  home_json="$(herdr workspace create --cwd "$HOME" --no-focus)"
  home_id="$(printf '%s' "$home_json" | json_field result.workspace.workspace_id)"
else
  echo "Reusing Home workspace: $home_id"
fi

# Find or create the project workspace.
project_id="$(find_workspace "$PROJECT_DIR")"
created=""
if [[ -n "$project_id" ]]; then
  echo "Reusing project workspace: $PROJECT_NAME"
else
  echo "Creating project workspace: $PROJECT_NAME"
  created="$(herdr workspace create --cwd "$PROJECT_DIR" --no-focus)"
  project_id="$(printf '%s' "$created" | json_field result.workspace.workspace_id)"
fi

# Inspect existing tabs. Never relaunch commands in existing tabs.
# Keep an existing default tab untouched; only the newly created
# workspace's initial tab is repurposed as the Editor tab.
tabs_json="$(herdr tab list --workspace "$project_id")"

tab_id_by_label() {
  local label="$1"
  printf '%s' "$tabs_json" | node -e '
    const fs = require("node:fs");
    const data = JSON.parse(fs.readFileSync(0, "utf8"));
    const tabs = data?.result?.tabs;
    if (!Array.isArray(tabs)) {
      console.error("Unexpected Herdr tab list response");
      process.exit(2);
    }
    const tab = tabs.find(t => t.label === process.argv[1]);
    if (tab) process.stdout.write(tab.tab_id);
  ' "$label"
}

create_tab() {
  local label="$1" command="$2" response pane_id
  response="$(herdr tab create --workspace "$project_id" --cwd "$PROJECT_DIR" --label "$label" --no-focus)"
  pane_id="$(printf '%s' "$response" | json_field result.root_pane.pane_id)"
  herdr pane run "$pane_id" "$command" >/dev/null
  echo "Created tab: $label"
}

ensure_tab() {
  local label="$1" command="$2"
  if [[ -n "$(tab_id_by_label "$label")" ]]; then
    echo "Reusing tab: $label"
    return 0
  fi
  if ! command -v "${command%% *}" >/dev/null 2>&1; then
    echo "Missing required tool: ${command%% *}" >&2
    exit 1
  fi
  # A newly created workspace already has an empty first tab.
  if [[ "$label" == Editor && -n "$created" ]]; then
    local tab_id pane_id
    tab_id="$(printf '%s' "$created" | json_field result.tab.tab_id)"
    pane_id="$(printf '%s' "$created" | json_field result.root_pane.pane_id)"
    herdr tab rename "$tab_id" Editor >/dev/null
    herdr pane run "$pane_id" 'nvim .' >/dev/null
    echo "Initialized tab: Editor"
  else
    create_tab "$label" "$command"
  fi
}

ensure_tab Editor 'nvim .'
ensure_tab Git lazygit
ensure_tab Containers lazydocker

herdr workspace focus "$project_id" >/dev/null
echo "Workspace ready: $PROJECT_NAME"
