#!/bin/bash --norc
set -euo pipefail

echo "Testing bash..."
time /bin/bash --rcfile .bashrc -c "true"

echo "Testing homebrew..."
HOMEBREW_NO_INSTALL_UPGRADE=1 xargs brew install --quiet <homebrew.packages

echo "Testing osx..."
time ./.osx

echo "Testing zsh..."
time /bin/zsh --no-rcs --interactive -c "set -euo pipefail; source .zshrc"
