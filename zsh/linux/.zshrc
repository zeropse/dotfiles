# User configuration
export EDITOR='nvim'
export VISUAL='nvim'

# Set personal aliases
alias zshconfig="vim ~/.zshrc"
alias vi='vim'
alias ls='ls --color=auto' # Enable color output for ls
alias open='dolphin'
alias open='dolphin .'

# Customize file and folder colors
export LS_COLORS="di=34:fi=37:ln=36:pi=33:so=35:bd=33:cd=33:or=31:mi=31:ex=32"

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
setopt emacs
setopt histignoredups
setopt no_beep
setopt interactive_comments


# Command-line history searching
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Zsh Plugins
source /home/zeropse/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/zeropse/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG="/.config/starship/starship.toml"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

