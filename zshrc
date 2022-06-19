# I like nvim
export EDITOR=nvim
export MAKEFLAGS="-j9 -l8"

# Auto completion stuff
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "${HOME}/.zshrc"

autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES

# History stuff
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd appendhistory
unsetopt beep

# Use vim keys
bindkey -v
bindkey "^R" history-incremental-search-backward

# Alias'
alias ls="ls --color=auto"
alias ll="ls -Al"
alias rm="rm -Iv"

# Canadian mode
alias please="sudo"

# Syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Fix termite's new tab functionality
#source /etc/profile.d/vte.sh
