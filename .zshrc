# Set Zsh options
PROMPT='zeropse %1~ %# '

# User configuration
export EDITOR='vim'
export VISUAL='vim'

# Set personal aliases
alias zshconfig="vim ~/.zshrc"

# Custom paths
export PATH="/Applications/XAMPP/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/bin/:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

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
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
