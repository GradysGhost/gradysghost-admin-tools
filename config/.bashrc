# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth 

# History settings
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Update the window size after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set a fancy prompt
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      color_prompt=yes
    else
      color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\e[0m\]\[\e[1m\]\[\e[36m\][$(date +%D\ %T)] \[\e[32m\]\u@\h:\[\e[34m\]\w\[\e[91m\]\$\[\e[0m\] '
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Enable color
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Some more ls aliases
alias ll='ls -lFh'
alias la='ls -Ah'
alias l='ls -CFh'
alias lathr='ls -lathr'

# Enable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Aliases
alias ..='cd ..'
alias git-root='while [ ! -d ./.git ]; do cd ..; done'
alias pypath='export PYTHONPATH=`pwd`'
alias rmpyc="find . -name '*.pyc' -print -delete"
alias shit='sudo $(fc -nl -1)'
alias sshconf='vim ~/.ssh/config'
alias susudio='sudo -i'

# Env-vars
export EDITOR=vim
export PATH=${PATH}:~/bin

# General aliases
alias ..='cd ..'
alias bashconf='vim ~/.bashrc'
alias pypath='export PYTHONPATH=`pwd`'
alias rebash='source ~/.bashrc'
alias rmpyc="find . -name '*.pyc' -print -delete"
alias shit='sudo $(fc -ln -1)'
alias sshconf='vim ~/.ssh/config'
alias susudio='sudo -i'

# Git aliases
alias add='git add'
alias branch='git branch'
alias branch-clean='git branch -d $(git branch | grep -v master)'
alias branch-clean-force='git branch -D $(git branch | grep -v master)'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit'
alias fetch='git fetch'
alias gref='git reflog -n1 2>/dev/null | cut -d " " -f1'
alias groot='while [ ! -d ./.git ]; do cd ..; done'
alias gsd='git status; git --no-pager diff'
alias log='git log'
alias pull='git pull'
alias push='git push'
alias rebase='git rebase -i'
alias stash='git stash'
alias status='git status'

