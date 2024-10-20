# Set Zsh options
PROMPT='zeropse %1~ %# '

# User configuration
export EDITOR='vim'
export VISUAL='vim'

# Set personal aliases
alias zshconfig="vim ~/.zshrc"
alias vi='vim'

# Custom paths

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt append_history
setopt extended_history

# Command-line history searching
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Zsh Plugins
source /home/zeropse/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/zeropse/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
