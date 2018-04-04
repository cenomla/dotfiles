# I like nvim
export EDITOR=nvim
export MAKEFLAGS="-j9 -l8"

powerline-daemon -q
. /usr/lib/python3.6/site-packages/powerline/bindings/zsh/powerline.zsh

# Auto completion stuff
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/cenomla/.zshrc'

autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES

# History stuff
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
unsetopt autocd beep
bindkey -v

# Alias'
alias ls="ls --color=auto"
alias ll="ls -Al"

