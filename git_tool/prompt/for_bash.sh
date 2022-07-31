#!/bin/bash

# https://linuxjf.osdn.jp/JFdocs/Bash-Prompt-HOWTO-3.html

# source /home/koba-masa/Documents/my_favorite_settings/git_tool/prompt/for_bash.sh
# export PS1="\[\e[32m\]\u\[\e[37m\]@\[\e[32m\]\h \[\e[37m\]\W \[\e[36m\]\$(__branch_name)\[\e[37m\]\$ "

function __branch_name() {
  local branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  if [ "${branch}" != "" ]; then
    branch="(${branch}) "
  fi
  echo "${branch}"
}
