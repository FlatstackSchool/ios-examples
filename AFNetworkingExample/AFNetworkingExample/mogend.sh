#!/bin/sh
#  mogend.sh

#  Check paths for generated files first! It can be different for every project
#  If something wrong with paths on your machine - use absolute path for mogenerator script
#  for enabling this script you should go to "Project target" -> "Build Rules" -> "Editor" -> "Add build Rule" -> select "Data model version files using Script" -> Process = "Data model version files" -> add custom script
        #echo "Running mogend"
        #"${SRCROOT}/${PROJECT_NAME}/Scripts/mogend.sh"
#  Set Output files = $(DERIVED_FILE_DIR)/${INPUT_FILE_BASE}.momd

mogenerator --swift --model "${INPUT_FILE_PATH}" --machine-dir "${PROJECT_DIR}/AFNetworkingExample/CoreData/Private/" --human-dir "${PROJECT_DIR}/AFNetworkingExample/CoreData/"

${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.7 "${INPUT_FILE_PATH}" "${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.momd"

echo "Mogend.sh is done"