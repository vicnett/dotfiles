# Zsh completion settings
autoload -Uz compinit && compinit
zinit cdreplay -q
# Completion matcher list:
# - try case-insensitive matching if nothing matches
# - partially match typed words (i.e. bar<tab> would match foobar)
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Highlight selected item in the menu
zstyle ':completion:*' menu select
# Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# automatically find new executables in path
zstyle ':completion:*' rehash true
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
