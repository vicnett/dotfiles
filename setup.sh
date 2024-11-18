#!/bin/sh

set -e

DOTFILES_DIR="$HOME/.dotfiles"
ANSIBLE_PATH="$HOME/.local/bin"
PLAYBOOK_PATH="$DOTFILES_DIR/ansible/playbook.yml"

# Detect distro
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
fi

if [ "$OS" = "Manjaro Linux" ] || [ "$OS" = "Arch Linux" ]; then
  sudo pacman -S --needed --noconfirm git python-pipx
elif [ "$OS" = "Ubuntu" ]; then
  sudo apt --assume-yes install git pipx
else
  echo "Distribution $OS not supported"
  exit 1
fi

pipx install --include-deps ansible
if [ ! -d "$DOTFILES_DIR" ]
then
  git clone --recurse-submodules https://github.com/vicnett/dotfiles.git "$DOTFILES_DIR"
fi

if [ -f "$PLAYBOOK_PATH" ]
then
  "$ANSIBLE_PATH/ansible-playbook" "$PLAYBOOK_PATH"
else
  echo "Ansible playbook not found at $PLAYBOOK_PATH"
  exit 1
fi
