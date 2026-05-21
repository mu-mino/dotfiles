#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${HOME}/dotfiles"

link_one() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -e "$source_path" ]]; then
    echo "ERROR: source missing: $source_path" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target_path")"
  rm -rf "$target_path"
  ln -s "$source_path" "$target_path"

  local resolved_target
  resolved_target="$(readlink "$target_path")"
  if [[ "$resolved_target" != "$source_path" ]]; then
    echo "ERROR: link mismatch for $target_path" >&2
    echo "       expected: $source_path" >&2
    echo "       got:      $resolved_target" >&2
    exit 1
  fi

  printf '%s -> %s\n' "$target_path" "$resolved_target"
}

link_one "$DOTFILES/kitty.conf" "$HOME/.config/kitty/kitty.conf"
link_one "$DOTFILES/config.fish" "$HOME/.config/fish/config.fish"
link_one "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"
link_one "$DOTFILES/speak.sh" "$HOME/utils/speak.sh"
link_one "$DOTFILES/nvim/nvim" "$HOME/.config/nvim"
link_one "$DOTFILES/ai/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link_one "$DOTFILES/ai/skills" "$HOME/.claude/skills"

echo "Symlink sync completed."
