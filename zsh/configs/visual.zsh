# Visual/style settings

# Color for autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

# Load dircolors
source $ZDOTDIR/dircolors.zsh

# Colors for fzf
# https://github.com/junegunn/fzf/wiki/Color-schemes#alternate-solarized-lightdark-theme
_gen_fzf_default_opts() {
  local base03  = "#002b36"
  local base02  = "#073642"
  local base01  = "#586e75"
  local base00  = "#657b83"
  local base0   = "#839496"
  local base1   = "#93a1a1"
  local base2   = "#eee8d5"
  local base3   = "#fdf6e3"
  local yellow  = "#b58900"
  local orange  = "#cb4b16"
  local red     = "#dc322f"
  local magenta = "#d33682"
  local violet  = "#6c71c4"
  local blue    = "#268bd2"
  local cyan    = "#2aa198"
  local green   = "#859900"

  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "
}
_gen_fzf_default_opts
