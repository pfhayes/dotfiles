#!/usr/bin/env bash
set -euo pipefail

BASE_PATH="${1:-/Users/patrick/Dropbox/dev/dotfiles}"
if [ ! -d "$BASE_PATH" ]; then
  echo >&2 "Expected $BASE_PATH to exist"
  exit 1
fi

OS="$(uname -s)"

# OS-specific setup first
if [ "$OS" = "Darwin" ]; then
  "$BASE_PATH/.osx"
elif [ "$OS" = "Linux" ]; then
  "$BASE_PATH/.linux"
fi

# Submodules
git -C "$BASE_PATH" submodule update --init

# Links
ln -sf "$BASE_PATH/.dircolors" ~/.dircolors
ln -sf "$BASE_PATH/.vim" ~/.vim
ln -sf "$BASE_PATH/.zsh" ~/.zsh

# Generated config files (use BASE_PATH instead of hardcoded Dropbox path)
mkdir -p ~/.config/nvim
cat > ~/.config/nvim/init.lua <<EOF
vim.cmd([[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source $BASE_PATH/.nvimrc
]])
EOF

cat > ~/.vimrc <<EOF
source $BASE_PATH/.vimrc
EOF

cat > ~/.zshrc <<EOF
setopt ALL_EXPORT

source $BASE_PATH/.zshrc
EOF

cat > ~/.gitconfig <<EOF
[include]
  path = $BASE_PATH/.gitconfig
EOF

# Claude Code
if ! command -v claude &>/dev/null; then
  curl -fsSL https://claude.ai/install.sh | bash
  claude login
fi

# Vim plugins
if command -v vim &>/dev/null; then
  tty_state=$(stty -g 2>/dev/null)
  vim +PlugUpdate +qall </dev/null
  [ -n "$tty_state" ] && stty "$tty_state" 2>/dev/null || true
fi
