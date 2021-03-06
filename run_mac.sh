#!/bin/bash

if [ $# != 2 ]; then
  echo "USAGE: sh run.sh input output"
  echo "input: directory or file"
  echo "output: directory or file"
  exit 1
fi


INPUT=$1
OUTPUT=$2

UPGRADE_MDL="api_upgrade_src"
UPGRADE_FILE="upgrade_models_api_run.py"

CUR_FOLDER=$(dirname $(greadlink -f "$0"))

if [ -d ${INPUT} ]
then
  if [ ! -d ${UPGRADE_MDL} ]; then
    echo "api_upgrade_src module does not exist, please clone the code"
    exit 1
  fi

  if [ ! -f ${UPGRADE_FILE} ]; then
    echo "upgrade_models_api_run.py does not exist, please clone the code"
    exit 1
  fi

  if [ ! -d "${INPUT}/${UPGRADE_MDL}" ]; then
    # cp -r ${UPGRADE_MDL} ${INPUT}
    rsync -av --progress ${UPGRADE_MDL} ${INPUT} --exclude="*/tests/*"
  fi

  if [ ! -f "${INPUT}/${UPGRADE_FILE}" ]; then
    # cp ${UPGRADE_FILE} ${INPUT}
    rsync -av --progress ${UPGRADE_FILE} ${INPUT} --exclude="*/tests/*"
  fi

  cd ${INPUT}
  output_fir="${CUR_FOLDER}/${OUTPUT}"
  config_file="./api_upgrade_src/conf/upgrade.conf"
  gsed -i "1c input_path=${INPUT}" ${config_file}
  gsed -i "2c output_path=${output_fir}" ${config_file}
  python3 ${UPGRADE_FILE}

  if [ -d "${UPGRADE_MDL}" ]; then
    rm -r ${UPGRADE_MDL}
  fi

  if [ -f "${UPGRADE_FILE}" ]; then
    rm ${UPGRADE_FILE}
  fi

  cd ${CUR_FOLDER}
elif [ -f ${INPUT} ]
then
  prefix="./"
  INPUT=${INPUT#$prefix}
  ls -l | grep "${INPUT}"
  cur_stat=$?
  filename=${INPUT}
  if [ ${cur_stat} == 1 ]; then
      dir_name=$(dirname ${INPUT})
      filename=${INPUT##*/}
      
      if [ ! -d " ${dir_name}/${UPGRADE_MDL}" ]; then
        # cp -r ${UPGRADE_MDL} ${dir_name}
        rsync -av --progress ${UPGRADE_MDL} ${dir_name} --exclude="*/tests/*"
      fi
      
      if [ ! -f " ${dir_name}/${UPGRADE_FILE}" ]; then
        # cp ${UPGRADE_FILE} ${dir_name}
        rsync -av --progress ${UPGRADE_FILE} ${dir_name} --exclude="*/tests/*"
      fi
      
      cd ${dir_name}
  fi
  output_fir="${CUR_FOLDER}/${OUTPUT}"
  config_file="./api_upgrade_src/conf/upgrade.conf"
  gsed -i "1c input_path=${filename}" ${config_file}
  gsed -i "2c output_path=${output_fir}" ${config_file}
  python3 ${UPGRADE_FILE}
  if [ ${cur_stat} == 1 ]; then
      if [ -d "${UPGRADE_MDL}" ]; then
        rm -r ${UPGRADE_MDL}
      fi
      
      if [ -f "${UPGRADE_FILE}" ]; then
        rm ${UPGRADE_FILE}
      fi
      
      cd ${CUR_FOLDER}
  fi

fi


