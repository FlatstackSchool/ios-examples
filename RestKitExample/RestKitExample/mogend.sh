#!/bin/sh
#  mogend.sh
#
#  Created by Jean-Denis Muys on 24/02/11.
#  Modified by Ryan Rounkles on 15/5/11 to use correct model version and to account for spaces in file paths
#  Edited by MD for GPNCard

#TODO: Change this to the name of custom ManagedObject base class (if applicable)
#  If no custom MO class is required, remove the "--base-class $baseClass" parameter from mogenerator call
#baseClass=DOManagedObject


PROJECT_NAME="RestKitExample"

HUMAN_DIR="${PROJECT_DIR}/$PROJECT_NAME/CoreData/Models"
MACHINE_DIR="$HUMAN_DIR/Private"

mogenerator --swift --model "${INPUT_FILE_PATH}" --machine-dir "$MACHINE_DIR" --human-dir "$HUMAN_DIR"

${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.7 "${INPUT_FILE_PATH}" "${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.momd"

echo "Mogend.sh is done"