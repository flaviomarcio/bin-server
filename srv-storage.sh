#!/bin/bash

. envs

if [[ ${BIN_SRV_DATA_PATH} == "" ]]; then
  export BIN_SRV_DATA_PATH=${HOME}/bin-server-data
fi

if [[ ${BIN_SRV_BACKUP_PATH} == "" ]]; then
  export BIN_SRV_BACKUP_PATH=${BIN_SRV_DATA_PATH}/backup
fi


if [[ ${BIN_SRV_DOCKER_PATH} == "" ]]; then
  export BIN_SRV_DOCKER_PATH=${BIN_SRV_DATA_PATH}/docker
  export BIN_SRV_DOCKER_BACKUP=${BIN_SRV_DOCKER_PATH}/backup
fi

function storageMaker()
{
  mkdir -p ${BIN_SRV_DATA_PATH}
  mkdir -p ${BIN_SRV_BACKUP_PATH}
  mkdir -p ${BIN_SRV_DOCKER_PATH}
  mkdir -p ${BIN_SRV_DOCKER_BACKUP}
}


