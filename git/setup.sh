#!/bin/sh

BASE_DIR=`dirname ${0}`

cd ${BASE_DIR}

FILE_DIR=`pwd`

option=""
if [ $# -ne 0 ]; then
  option="${1}"
fi

global_settings="${FILE_DIR}/global_settings"

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

cd ${BASE_DIR}
cat ~/.gitconfig
