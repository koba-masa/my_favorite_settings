#!/bin/zsh

function git_prompt() {
  local color_default=white
  local color_user=green
  local color_host=green
  local color_cd=white
  local color_branch=cyan
  local branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  if [ "${branch_name}" != "" ]; then
    branch_name="%F{${color_branch}}(${branch_name})%f "
  fi
  PROMPT="%F{${color_user}}%n%f%F{${color_default}}@%f%F{${color_host}}%m%f %F{${color_default}}%1~%f ${branch_name}%F{${color_default}}%#%f "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd git_prompt
