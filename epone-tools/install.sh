#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="${HOME}/.local/bin"

mkdir -p "$bin_dir"
ln -sf "$repo_dir/bin/epone" "$bin_dir/epone"
chmod +x "$repo_dir/bin/epone"

case ":$PATH:" in
  *":$bin_dir:"*) ;;
  *)
    printf 'Installed, but %s is not in PATH.\n' "$bin_dir"
    printf 'Add this to your shell profile:\n\n  export PATH="$HOME/.local/bin:$PATH"\n\n'
    exit 0
    ;;
esac

printf 'Installed. Run: epone\n'
