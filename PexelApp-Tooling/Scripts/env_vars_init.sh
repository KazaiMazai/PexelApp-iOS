#!/bin/bash

# This script should be run as a phase script before building the project
#
# The script:
# 1. Copies .env-example.xcconfig to .env.xcconfig if .env.xcconfig does not exist

if [ $ACTION = "indexbuild" ]; then exit 0; fi

echo "EnvironmentVars init"

CONFIGURATION_PATH="${SRCROOT}/PexelApp-iOS/PexelApp-iOS/Configuration/EnvironmentVars"
TEMPLATE_PATH="${CONFIGURATION_PATH}/EnvironmentVars.stencil"

# Path to the env.xcconfig file
xcconfig_file="${CONFIGURATION_PATH}/env.xcconfig"

if [ -f "$xcconfig_file" ]; then
  echo "The file '$xcconfig_file' found."
else
  echo "The file '$xcconfig_file' does not exist."
  example_xcconfig_file="${CONFIGURATION_PATH}/env-example.xcconfig"
  cp "$example_xcconfig_file" "$xcconfig_file"
  echo "Copied from '$example_xcconfig_file' to '$xcconfig_file'"
fi


