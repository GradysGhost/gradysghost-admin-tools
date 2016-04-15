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
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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
alias ll='ls -alFh'
alias la='ls -Ah'
alias l='ls -CFh'

# Enable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
complete -C '/usr/bin/aws_completer' aws

# Aliases
alias ..='cd ..'
alias git-root='while [ ! -d ./.git ]; do cd ..; done'
alias pypath='export PYTHONPATH=`pwd`'
alias rmpyc="find . -name '*.pyc' -print -delete"
alias shit='sudo $(fc -nl -1)'
alias sshconf='vim ~/.ssh/config'
alias susudio='sudo -i'

# Env-vars
export PATH=${PATH}:~/bin
export EDITOR=vim

