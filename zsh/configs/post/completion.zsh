# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion
autoload -U compinit
compinit

# do not autoselect first completion
unsetopt menu_complete
# show menu on first autocomplete
setopt auto_menu

# enable menu select
zstyle ':completion:*:*:*:*:*' menu select

zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order \
  local-directories \
  directory-stack \
  path-directories
