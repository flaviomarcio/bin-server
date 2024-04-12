#!/bin/bash

export COLOR_OFF='\e[0m'
export COLOR_BACK='\e[0;30m'
export COLOR_BACK_B='\e[1;30m'
export COLOR_RED='\e[0;31m'
export COLOR_RED_B='\e[0;31m'
export COLOR_GREEN='\e[0;32m'
export COLOR_GREEN_B='\e[1;32m'
export COLOR_YELLOW='\e[0;33m'
export COLOR_YELLOW_B='\e[2;33m'
export COLOR_BLUE='\e[0;34m'
export COLOR_BLUE_B='\e[1;34m'
export COLOR_MAGENTA='\e[0;35m'
export COLOR_MAGENTA_B='\e[1;35m'
export COLOR_CIANO='\e[0;36m'
export COLOR_CIANO_B='\e[1;36m'
export COLOR_WHITE='\e[0;37m'
export COLOR_WHITE_B='\e[1;37m'

function clearTerm()
{
  if [[ ${PUBLIC_LOG_LEVEL} != true ]]; then
    clear
  fi
}

function echoColor()
{
  echo -e "${1}${2}${COLOR_OFF}"
}

function echR()
{
  echoColor ${COLOR_RED} "$@"
}


function echE()
{
  echoColor ${COLOR_RED} "$@"
}

function echG()
{
  echoColor ${COLOR_GREEN} "$@"
}

function echY()
{
  echoColor ${COLOR_YELLOW} "$@"
}

function echB()
{
  echoColor ${COLOR_BLUE} "$@"
}

function echM()
{
  echoColor ${COLOR_MAGENTA} "$@"
}

function echC()
{
  echoColor ${COLOR_CIANO} "$@"
}

function osInformationPrint()
{
  local __docker_daemon=/etc/docker/daemon.json
  if [[ -f ${__docker_daemon} ]]; then
    local __docker_root_dir=$(cat ${__docker_daemon} | sed 's/data-root/data_root/g' | jq '.data_root' | sed 's/\"//g')
    local __docker_tls=$(cat ${__docker_daemon} | jq '.tls')
    local __docker_cert=$(cat ${__docker_daemon} | jq '.tlscert')
  else
    local __docker_root_dir="UNDEFINED"
    local __docker_tls="UNDEFINED"
    local __docker_cert="UNDEFINED"
  fi

  local __docker_info="Docker: ${COLOR_YELLOW}"$(docker --version | sed 's/Docker //g')
  echG "OS informations"
  echC "  - $(uname -a)"
  echC "  - ${__docker_info}${COLOR_CIANO}, IPv4: ${COLOR_YELLOW}${PUBLIC_HOST_IPv4}${COLOR_CIANO}, root-dir: ${COLOR_YELLOW}${__docker_root_dir}"
  if [[ ${__docker_tls} == true ]]; then
    echC "    - tls: ${COLOR_YELLOW}${__docker_tls} ${COLOR_CIANO}, cert: ${COLOR_YELLOW}$(dirname ${__docker_cert})"
  fi
}

function selector()
{
  unset __selector
  local __selector_title=${1}
  local __selector_args=${2}
  local __selector_clear=${3}
  if [[ ${__selector_args} == "" ]]; then
    return 0
  fi
  if [[ ${__selector_clear} == "" ]]; then
    local __selector_clear=true
  fi

  if [[ ${__selector_clear} == true ]]; then
    clearTerm
    osInformationPrint
  fi

  while :
  do
    clearTerm
    osInformationPrint
    echM $'\n'"${__selector_title}"$'\n'
    PS3=$'\n'"Selecione uma opção: "
    local options=(${__selector_args})
    select opt in "${options[@]}"
    do
      arrayContains "${__selector_args}" "${opt}"
      if ! [ "$?" -eq 1 ]; then
        break;
      fi

      export __selector=${opt}
      if [[ ${opt} == "back" ]]; then
        return 0;
      elif [[ ${opt} == "quit" ]]; then
        return 2;
      elif [[ ${opt} == "all" ]]; then
        export __selector=${__selector_args}
      fi
      return 1;
    done
  done
  return 0;
}


function selectorYesNo()
{
  local __selector_title=${1}
  selector "${__selector_title}" "Yes No"
  if [[ ${__selector} == "Yes" ]]; then
    return 1;
  fi
  return 0
}


function selectorWaitSeconds()
{
  local __selectorWaitSeconds_seconds=${1}
  local __selectorWaitSeconds_title=${2}
  local __selectorWaitSeconds_color=${2}

  if [[ ${__selectorWaitSeconds_seconds} == "" ]]; then
    local __selectorWaitSeconds_seconds=10
  fi

  if [[ ${__selectorWaitSeconds_title} == "" ]]; then
    local __selectorWaitSeconds_title="Wainting ${__selectorWaitSeconds_seconds} seconds, use [CTRL+C] to abort..."
  fi

  if [[ ${__selectorWaitSeconds_color} == "" ]]; then
    local __selectorWaitSeconds_color=${COLOR_BLUE_B}
  fi

  echo -e "${__selectorWaitSeconds_color}${__selectorWaitSeconds_title}${COLOR_OFF}"
  for i in $(seq ${__selectorWaitSeconds_seconds} -1 0); do echo -e -n "${i}... "; sleep 1; done; echo -e "\n"

  return 1
}

function strTrim()
{
  echo "$@" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}