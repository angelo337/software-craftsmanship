#!/usr/bin/env bash
# Usage: ./install.sh [--user | --project] [--uninstall]   (default: --user)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.claude/skills"; mode=install
for a in "$@"; do case $a in
  --user) dest="$HOME/.claude/skills";;
  --project) dest="$PWD/.claude/skills";;
  --uninstall) mode=uninstall;;
  *) echo "unknown option $a"; exit 1;; esac; done
for s in "$here"/plugins/software-craftsmanship/skills/*/; do n=$(basename "$s")
  if [ $mode = install ]; then mkdir -p "$dest"; rm -rf "$dest/$n"; cp -r "$s" "$dest/$n"; echo "installed $n"
  else rm -rf "$dest/$n"; echo "removed $n"; fi
done
echo "Done -> $dest. Restart Claude Code (or start a new session)."
