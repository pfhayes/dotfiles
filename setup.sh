#!/usr/bin/env bash
set -euo pipefail

BASE_PATH="${1:-/Users/patrick/Dropbox/dev/dotfiles}"
if [ ! -d "$BASE_PATH" ]; then
  echo >&2 "Expected $BASE_PATH to exist"
  exit 1
fi

OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
  # Xcode tools
  if ! xcode-select -p; then
    xcode-select --install
  fi

  # Homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
  brew update
  brew upgrade
  xargs brew install <homebrew.packages
  brew install --cask font-source-code-pro
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
if command -v nvim &>/dev/null; then
  nvim --headless +PlugUpdate +qall
fi

# OS-specific preferences
if [ "$OS" = "Darwin" ]; then
  "$BASE_PATH/.osx"
  cp "$BASE_PATH/com.apple.Terminal.plist" ~/Library/Preferences/com.apple.Terminal.plist
  chsh -s /bin/zsh

  echo 'TODO(patrick): Set mouse tap to click'
  echo 'TODO(patrick): Update tracking speed'
  echo 'TODO(patrick): Configure displays to optimize for retina display'
  echo 'TODO(patrick): Set up SSH keys'
elif [ "$OS" = "Linux" ]; then
  "$BASE_PATH/.linux"
fi
