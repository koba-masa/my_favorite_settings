#!/bin/sh

BASE_DIR=`dirname ${0}`

option=""
if [ $# -ne 0 ]; then
  option="${1}"
fi

git_message="${BASE_DIR}/global_settings/.gitmessage"
if [ -e "${git_message}.${option}" ]; then
  git_message="${git_message}.${option}"
fi
git config --global commit.template ${git_message}

