# User configuration
export EDITOR='nvim'
export VISUAL='nvim'

# Set personal aliases
alias zshconfig="nvim ~/.zshrc"

# Custom paths
export PATH="/opt/homebrew/bin/:$PATH" # For Homebrew
# export PATH="$HOME/.cargo/bin:$PATH" (FOR RUST DEVELOPMENT) 

# History setup
HISTFILE=$HOME/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_find_no_dups
setopt append_history
setopt extended_history
setopt inc_append_history
setopt hist_reduce_blanks

# Command-line history searching
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Zsh Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable last-login time
[[ -f ~/.hushlogin ]] || touch ~/.hushlogin

# Starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"