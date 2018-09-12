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
    PS1='$(~/.ps1.sh)\n> '
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
alias bashconf='vim ~/.bashrc'
alias generate_password='apg -n16 -x32 -a1 -MSNCL -n1'
alias generate_tokens='~/workspace/clearcare/misc-devops/scripts/get_aws_sts_token.py --user rjung --golden_config ~/.aws.conf --temp_config ~/.aws.temp.conf'
alias pypath='export PYTHONPATH=`pwd`'
alias rebash='source ~/.bashrc'
alias rmpyc="find . -name '__pycache__' -o -name '*.pyc' -print -exec rm -rf {} \;"
alias shit='sudo $(fc -ln -1)'
alias sqlite='sqlite3'
alias sshconf='vim ~/.ssh/config'
alias susudio='sudo -i'
alias vpn='sudo openvpn ~/vpns/prod.ovpn'
alias elba='export LATEST_BASE_AMI=$(ami-latest-base)'
alias json='python -m json.tool'

# Git aliases
alias add='git add'
alias branch='git branch'
alias branch-clean='git branch -d $(git branch | grep -v master)'
alias branch-clean-force='git branch -D $(git branch | grep -v master)'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit'
alias fetch='git fetch'
alias merge='git merge'
alias groot='while [ ! -d ./.git ]; do cd ..; done'
alias gsd='git status; git --no-pager diff'
alias log='git log'
alias pull='git pull'
alias push='git push'
alias rebase='git rebase -i'
alias stash='git stash'
alias status='git status'

# Env-vars
export EDITOR=vim
export AWS_CONFIG_FILE=~/.aws.conf
export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.6

export PATH=${PATH}:~/bin

# Functions
source /usr/bin/virtualenvwrapper.sh &> /dev/null

function utc {
  if [ -z $UTC ]; then
    export UTC=0
  fi

  if [ $UTC -eq 1 ]; then
    export UTC=0
  else
    export UTC=1
  fi
}

function vim {
  fileref=$1
  if [[ $fileref = *":"* ]]; then
    file=$(echo $fileref | cut -d: -f1)
    line=$(echo $fileref | cut -d: -f2)
    if [ -z $line ]; then
      echo "/usr/bin/vim $@"
      /usr/bin/vim $@
    else
      echo "/usr/bin/vim $file +$line"
      /usr/bin/vim $file +$line
    fi
  else
    echo "/usr/bin/vim $@"
    /usr/bin/vim $@
  fi
}
alias plainvim='/usr/bin/vim'

function grepvim {
  /usr/bin/vim $(grep -rin "$1" * | grep -v '^Binary' | cut -d: -f1 | sort -u)
}

if [ ! $TMUX ]; then tmux new; fi

