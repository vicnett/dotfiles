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

# Handle nvim directory linking
echo Checking for existing nvim config directory...
if [[ -h $OG_NVIM_DIR_PATH ]] &&
  [[ "$(readlink -f $OG_NVIM_DIR_PATH)" = $NVIM_DIR_PATH ]]
then
  echo nvim config directory already points to dotfile location. \
    No action taken.
elif [[ -d "$OG_NVIM_DIR_PATH" ]]; then
  echo nvim config directory exists. Saving OG as nvim.og and \
    replacing with link to dotfile location...
  mv $OG_NVIM_DIR_PATH $OG_NVIM_DIR_PATH.og && ln -s $NVIM_DIR_PATH \
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

# ==================
# == Begin byobu ===
# ==================

# Define paths
BYOBU_DIR_PATH="$BASEDIR/byobu"
OG_BYOBU_DIR_PATH="$HOME/.byobu"

# Handle .byobu directory linking
echo Checking for existing byobu config directory...
if [[ -h $OG_BYOBU_DIR_PATH ]] &&
  [[ "$(readlink -f $OG_BYOBU_DIR_PATH)" = $BYOBU_DIR_PATH ]]
then
  echo byobu config directory already points to dotfile location. \
    No action taken.
elif [[ -d "$OG_BYOBU_DIR_PATH" ]]; then
  echo byobu config directory exists. Saving OG as byobu.og and \
    replacing with link to dotfile location...
  mv $OG_BYOBU_DIR_PATH $OG_BYOBU_DIR_PATH.og && ln -s $BYOBU_DIR_PATH \
$OG_BYOBU_DIR_PATH
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
else
  echo byobu config directory does not exist. Make sure Byobu is installed! \
    Creating link to dotfile location...
  ln -s $BYOBU_DIR_PATH $OG_BYOBU_DIR_PATH
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
fi

# ================
# == End byobu ===
# ================

# ================
# == Begin git ===
# ================

# Define paths
OG_GITCONFIG_PATH="$HOME/.gitconfig"
GIT_ALIAS_PATH="$BASEDIR/aliases/git"

echo Checking .gitconfig includes...
grep -qF "[include]" $OG_GITCONFIG_PATH
if [[ $? -ne 0 ]]
then
  echo No [include] section found in .gitconfig. \
    Adding ours...
  git config --global include.path "$GIT_ALIAS_PATH"
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
else
  echo [include] section found in .gitconfig \
    Checking for ours...
  grep -qF "path = $GIT_ALIAS_PATH" $OG_GITCONFIG_PATH
  if [[ $? -ne 0 ]]
  then
    echo Our aliases aren\'t included. \
      Adding...
    sed -i '' "/^\[include\]$/a\\
	path = $GIT_ALIAS_PATH/
" $OG_GITCONFIG_PATH
  if [[ $? -eq 0 ]]
  then
    echo Success!
  else
    echo "Something went wrong :("
    exit 1
  fi
  else
    echo Our aliases are already included. \
      No action taken.
  fi
fi

# ==============
# == End git ===
# ==============
