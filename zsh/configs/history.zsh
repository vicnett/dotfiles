# Zsh history settings

HISTFILE="$ZDOTDIR/.zhistory"
HISTSIZE=10000
SAVEHIST=$HISTSIZE

# Save timestamps in history file
setopt extended_history
# Persistent history file
setopt append_history
# Write to the history file upon running each command, not upon exiting shell
setopt inc_append_history
# Delete the older event if a new event is a duplicate of it
setopt hist_ignore_all_dups
# Don't write to history if the command starts with a space
setopt hist_ignore_space

# Search history using already-typed text with up/down arrows
zinit load 'zsh-users/zsh-history-substring-search'
zinit ice wait atload'_history_substring_search_config'
# Key bindings for using zsh-history-substring-search via up/down arrows
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# Colors for matching and non-matching search terms
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=blue'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red'
# Only match commands that start the same as the search term
HISTORY_SUBSTRING_SEARCH_PREFIXED='foo' # it just needs to be non-empty
