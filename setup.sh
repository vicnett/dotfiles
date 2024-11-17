#!/bin/sh

set -e

DOTFILES_DIR="$HOME/.dotfiles"
ANSIBLE_PATH="$HOME/.local/bin"
PLAYBOOK_PATH="$DOTFILES_DIR/ansible/playbook.yml"

sudo pacman -S --needed --noconfirm git python-pipx
pipx install --include-deps ansible

if [ ! -d $DOTFILES_DIR ]
then
  git clone --recurse-submodules https://github.com/vicnett/dotfiles.git $DOTFILES_DIR
fi

if [ -f $PLAYBOOK_PATH ]
then
  $ANSIBLE_PATH/ansible-playbook $PLAYBOOK_PATH
else
  echo Ansible playbook not found at $PLAYBOOK_PATH
  exit 1
fi
