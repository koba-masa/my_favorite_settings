#!/bin/sh

BASE_DIR=`dirname ${0}`

option=""
if [ $# -ne 0 ]; then
  option="${1}"
fi

global_settings="${BASE_DIR}/global_settings"

git_ignore="${global_settings}/.gitignore"
if [ -e "${git_ignore}.${option}" ]; then
  git_ignore="${git_ignore}.${option}"
fi
git config --global core.excludesFile ${git_ignore}

git_message="${global_settings}/.gitmessage"
if [ -e "${git_message}.${option}" ]; then
  git_message="${git_message}.${option}"
fi
git config --global commit.template ${git_message}

