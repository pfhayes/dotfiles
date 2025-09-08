#!/usr/bin/env bash
set -euo pipefail

BASE_PATH=/Users/patrick/Dropbox/dev/dotfiles
if [ ! -d "$BASE_PATH" ]; then
  echo >&2 "Expected $BASE_PATH to exist"
  exit 1
fi

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

# Links
[ -f ~/.config/nvim/init.lua ] || cp -f "$BASE_PATH/.nvim.init.lua.local" ~/.config/nvim/init.lua
[ -L ~/.dircolors ] || ln -sf "$BASE_PATH/.dircolors" ~/.dircolors
[ -L ~/.vim ] || ln -sf "$BASE_PATH/.vim" ~/.vim
[ -L ~/.zsh ] || ln -sf "$BASE_PATH/.zsh" ~/.zsh
[ -f ~/.gitconfig ] || cp -f "$BASE_PATH/.gitconfig.local" ~/.gitconfig
[ -f ~/.vimrc ] || cp -f "$BASE_PATH/.vimrc.local" ~/.vimrc
[ -f ~/.zshrc ] || cp -f "$BASE_PATH/.zshrc.local" ~/.zshrc

cd ~

# Preferences
./.osx
cp com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist
chsh -s /bin/zsh

echo 'TODO(patrick): Set caps lock to control'
echo 'TODO(patrick): Set mouse tap to click'
echo 'TODO(patrick): Update tracking speed'
echo 'TODO(patrick): Configure displays to optimize for retina display'
echo 'TODO(patrick): Set up SSH keys'
