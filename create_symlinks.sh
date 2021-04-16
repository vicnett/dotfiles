#!/bin/bash

# Script to generate symbolic links to dotfiles

# Determine the absolute directory path to this script
# This is where the other dotfiles should be and will be used to build the link
# targets.
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# ================
# == Begin zsh ===
# ================

# Define paths
ZSHRC_PATH="$BASEDIR/zsh/zshrc"
OG_ZSHRC_PATH="$HOME/.zshrc"
OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"
# Stop if oh-my-zsh doesn't seem to be installed
if [[ ! -d "$OH_MY_ZSH_PATH" ]]
then
  echo oh-my-zsh directory not found. Please install oh-my-zsh.
  exit 1
fi

# Handle .zshrc linking
echo Checking for existing .zshrc...
if [[ -h $OG_ZSHRC_PATH ]] && [[ "$(readlink -f $OG_ZSHRC_PATH)" = $ZSHRC_PATH ]]
then
  echo .zshrc already points to dotfile location. No action taken.
elif [[ -f "$OG_ZSHRC_PATH" ]]; then
  echo .zshrc exists. Saving OG as .zshrc.og and \
    replacing with link to dotfile location...
  mv $OG_ZSHRC_PATH $OG_ZSHRC_PATH.og && ln -s $ZSHRC_PATH $OG_ZSHRC_PATH
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
else
  echo .zshrc does not exist. Make sure zsh is installed! \
    Creating link to dotfile location...
  ln -s $ZSHRC_PATH $OG_ZSHRC_PATH
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
fi

# ==============
# == End zsh ===
# ==============

# =================
# == Begin nvim ===
# =================

# Define paths
NVIM_DIR_PATH="$BASEDIR/vim"
OG_NVIM_DIR_PATH="$HOME/.config/nvim"

# Handle .zshrc linking
echo Checking for existing nvim config directory...
if [[ -h $OG_NVIM_DIR_PATH ]] &&
  [[ "$(readlink -f $OG_NVIM_DIR_PATH)" = $NVIM_DIR_PATH ]]
then
  echo nvim config directory already points to dotfile location. \
    No action taken.
elif [[ -d "$OG_NVIM_DIR_PATH" ]]; then
  echo nvim config directory exists. Saving OG as nvim.og and \
    replacing with link to dotfile location...
  mv $OG_NVIM_DIR_PATH $OG_NVIM_DIR_PATH.og && ln -s $NVIM_DIR_PATH
  $OG_NVIM_DIR_PATH
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
else
  echo nvim config directory does not exist. Make sure neovim is installed! \
    Creating link to dotfile location...
  ln -s $NVIM_DIR_PATH $OG_NVIM_DIR_PATH
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
fi

# ===============
# == End nvim ===
# ===============
