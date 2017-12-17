#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias ll='ls -l'
alias cl='clear'

alias def='/usr/bin/sdcv'

alias vi='vim'
alias vd='vimdiff'
alias gdiff='gvimdiff'
alias em='emacs'
alias tm='tmux -2'
alias ta='tmux a'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
