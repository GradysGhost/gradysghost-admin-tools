#!/bin/bash

get_date () {
  if [ -z $UTC ]; then
    export UTC=0
  fi

  if [ $UTC -eq 1 ]; then
    echo "$(date -u +%D\ %T) UTC"
  else
    echo "$(date +%D\ %T) MT"
  fi
}

is_git_repo () {
  git status &> /dev/null
  if [ $? -eq 0 ]; then
    echo 1
  fi
  echo 0
}

git_str () {
  if [[ "$(is_git_repo)" == "0" ]]; then
    echo ""
  else
    branch=$(git status | grep '^On branch' | sed 's/On\ branch\ \(.*\)/\1/')
    echo " ($branch)"
  fi
}

date=$(get_date)
user=$(whoami)
host=$(hostname)
dir=$(pwd | sed 's/\/home\/rjung/~/')

tput bold
tput setaf 6
printf "[%s] " "$date"
tput setaf 2
printf "%s@%s:" "$user" "$host"
tput setaf 4
printf "%s" "$dir"
tput setaf 3
printf "%s" "$(git_str)"
tput setaf 1
printf '$ '
tput sgr0


