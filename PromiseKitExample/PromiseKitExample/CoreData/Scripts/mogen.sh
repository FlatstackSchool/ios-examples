#!/bin/sh

#  mogen.sh
#  test
#
#  Created by Corner room on 15/04/15.
#  Copyright (c) 2015 Corner room. All rights reserved.
HUMAN_DIR="${PROJECT_DIR}/PromiseKitExample/CoreData/Entities"
MACHINE_DIR="${PROJECT_DIR}/PromiseKitExample/CoreData/EntitiesMachine"
INCLUDE_H="${PROJECT_DIR}/PromiseKitExample/CoreData/ModelIncludes.h"

echo mogenerator --model \"${INPUT_FILE_PATH}\" --machine-dir "$MACHINE_DIR/" --human-dir "$HUMAN_DIR/" --includeh "$INCLUDE_H" --template-var arc=true
/usr/local/bin/mogenerator --model \"${INPUT_FILE_PATH}\" --machine-dir "$MACHINE_DIR/" --human-dir "$HUMAN_DIR/" --includeh "$INCLUDE_H" --template-var arc=true

echo ${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.6 \"${INPUT_FILE_PATH}\" \"${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.mom\"
${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.6 "${INPUT_FILE_PATH}" "${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.mom"

echo "that's all folks. mogen.sh is done"