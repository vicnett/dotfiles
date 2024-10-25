#!/usr/bin/env bash

set -e

sudo pacman -S --needed --noconfirm git python-pipx
export PATH="$PATH:~/.local/bin"
pipx install --include-deps ansible

ansible-playbook ansible/playbook.yml
