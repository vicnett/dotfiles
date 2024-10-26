# Test/dev environment

Figure out how to do the following (not necessarily completely get it all done
but at least establish the patterns):

- [X] Docker:
    - [X] Build simble "base" Manjaro Docker image
    - [X] Get things to run in Docker based on the HEAD of a given branch
    - [X] Get things to run in Docker based on the current (dirty) local repo
    state
- [O] Ansible:
    - [X] Install system packages
    - [ ] Install plugin managers + plugins
        - [ ] zsh
        - [ ] tmux
        - [ ] nvim
    - [X] Run Dotbot
- [X] Dotbot:
    - [X] Create files/directories
    - [X] Link dotfiles

# tmux/byobu

- mostly keep existing config, it's good
- make sure plugin manager and plugins are included
- except clean up the byobu statusline...
- look into auto-resuming sessions, including vim status and terminal history

# zsh / shell/cli in general

zsh-specific:
- don't use oh-my-zsh or any other pre-made config/framework (main zsh-related
  reason for starting over)
- nice prompt
- solarized colors
- plugin manager (zinit) and plugins:
    * zsh-syntax-highlighting
    * zsh-completions
    * zsh-autosuggestions
- finally figure out how completion scripts work
- don't add to history if leading space

shell stuff to set up:
- fuzzy-finding:
    * files
    * command history
- mouse support (including scrolling in pagers and man pages)

shell stuff to look into:
- use exa instead of ls
- use zoxide instead of cd
- 1password CLI integration

# vim

- do as much as possible in LUA (main vim-related reason for starting over)
- plugin manager
- solarized theme
- plugins:
    * existing:
        + tcomment\_vim
        + vim-textobj-line
        + vim-textobj-user
        + vim-textobj-indent
        + bullets.vim
        + vim-repeat
        + vim-rhubarb
        + vim-solarized8
        + vim-css-color
        + vim-wordmotion
        + vim-obsession
        + vim-system-copy
        + vim-fugitive
        + vim-textobj-quotes
        + vim-sleuth
        + emmet-vim
        + vim-surround
        + csv.vim
        + vim-textobj-entire
        + vim-gutentags
        + vim-gitgutter
        + vim-textobj-codeblock
        + vim-easy-align
        + vim-lastplace
    * look into:
        + vim-visual-multi
- things to look into:
    * set up fancy status line
    * persist undo history `:h undo-persistence`
    * LSP (linting, autocomplete, autosuggest, navigation)
    * fuzzy-finder?


# Testing and development

- maintain Docker image(s) of base systems to test on
- basic automatable tests make sure bootstrap/install script works without error
- ability to get dropped into the test environment after running everything for manual testing and development
- learn and set up GitHub actions to automagically run tests both on a schedule
  and on every commit on the main branch


# Other stuff

- look into adding alacritty + config
