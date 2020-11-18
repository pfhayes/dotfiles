#!/usr/bin/env bash
set -e

# Xcode tools
if ! xcode-select -p; then
  xcode-select --install
fi

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
brew update
brew upgrade
xargs brew install <homebrew.packages
brew tap homebrew/cask-fonts
brew cask install font-source-code-pro

# Links
BASE_PATH=/Users/patrick/Dropbox/dev/dotfiles
[ -L ~/.ctags ] || ln -sf "$BASE_PATH/.ctags" ~/.ctags
[ -L ~/.dircolors ] || ln -sf "$BASE_PATH/.dircolors" ~/.dircolors
[ -L ~/.slate ] || ln -sf "$BASE_PATH/.slate" ~/.slate
[ -L ~/.vim ] || ln -sf "$BASE_PATH/.vim" ~/.vim
[ -L ~/.zsh ] || ln -sf "$BASE_PATH/.zsh" ~/.zsh
[ -f ~/.gitconfig ] || cp -f .gitconfig.local ~/.gitconfig
[ -f ~/.vimrc ] || cp -f .vimrc.local ~/.vimrc
[ -f ~/.zshrc ] || cp -f .zshrc.local ~/.zshrc

# Python
curl -OL https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
[ -f /usr/local/bin/pip ] || sudo ln -s /usr/local/bin/pip2 /usr/local/bin/pip
sudo pip install virtualenv

# Fix vim/ruby/commmand-t
git submodule init
git submodule sync
git submodule update
(
  cd ~/.vim/bundle/command-t
  brew unlink xz
  sudo gem install bundler
  bundle install
  bundle exec rake make
)
brew link xz

cd ~

# Init desktop
if [ ! -d ~/Desktop/Desktop ]; then
  touch ~/Desktop/fakefile
  mv ~/Desktop/* ~
  sudo rm -rf Desktop
  ln -s ~ ~/Desktop
  rm ~/Desktop/fakefile
fi

# Flux
curl -LO "https://justgetflux.com/mac/Flux.zip"
open Flux.zip

# Preferences
./.osx
cp com.apple.Terminal.plist ~/Library/Preferences/com.apple.Terminal.plist
chsh -s /bin/zsh

echo 'TODO(patrick): Set caps lock to control'
echo 'TODO(patrick): Set mouse tap to click'
echo 'TODO(patrick): Update tracking speed'
echo 'TODO(patrick): Configure displays to optimize for retina display'
echo 'TODO(patrick): Set up SSH keys'
