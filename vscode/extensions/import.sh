#!/bin/sh
EXTENSIONS="`dirname ${0}`/extensions.txt"

if [ ! -e "${EXTENSIONS}" ]; then
  echo "${EXTENSIONS} is not exist."
  exit 99
fi

for extension in `cat EXTENSIONS`
do
  code --install-extension "${extension}"
done
