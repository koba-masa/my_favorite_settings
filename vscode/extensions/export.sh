#!/bin/sh
EXTENSIONS="`dirname ${0}`/extensions.txt"
code --list-extensions > ${EXTENSIONS}
