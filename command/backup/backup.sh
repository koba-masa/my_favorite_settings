#!/bin/sh

readonly PADDINGNUM="%02d"

function help() {
  echo "-h help"
}

function targetExists() {
  local target=$1
  if [ ! -f ${target} -a ! -d ${target} ]; then
    echo "'${target}' does not exist."
    return 1
  fi
  return 0
}

function checkBranch() {
  local target=$1
  local count=1
  while :
  do
    local tmpTarget=${target}.`printf ${PADDINGNUM} ${count}`
    if [ ! -f ${tmpTarget} -a ! -d ${tmpTarget} ]; then
      break;
    fi
    ((count++))
  done
  return ${count}
}

if [ $# -eq 0 ]; then
   echo "A mount of parameter is wrong!!"
   exit 1
fi

paramCnt=$#
dirFlg=0
paramList=()
for i in `seq ${paramCnt}`
do
  param=${!i}
  case ${param} in
    "-d" )
      dirFlg=1
      ;;
    "-h" )
      help
      exit 0
      ;;
    * )
      targetExists ${param}
      if [ $? -ne 0 ]; then
        exit 1;
      fi
      paramList+=( ${param} )
      ;;
  esac
done

nowDate=`date '+%Y%m%d'`

if [ ${dirFlg} -eq 0 ]; then
  for target in ${paramList[@]}
  do
    checkBranch ${target}.${nowDate}
    branch=$?
    cp -rp ${target} ${target}.${nowDate}.`printf ${PADDINGNUM} ${branch}`
  done
else
  checkBranch ${nowDate}.
  branch=$?
  dirPath=${nowDate}.`printf ${PADDINGNUM} ${branch}`
  mkdir ${dirPath}
  for target in ${paramList[@]}
  do
    cp -rp ${target} ${dirPath}/.
  done
fi

exit 0

