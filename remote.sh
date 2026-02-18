#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${1:-$HOME/dotfiles}"

git clone https://github.com/pfhayes/dotfiles.git "$DOTFILES_DIR"

"$DOTFILES_DIR/setup.sh" "$DOTFILES_DIR"
