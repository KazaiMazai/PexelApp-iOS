#!/bin/bash

# This script could be run as a phase script if env vars needed
#
# The script:
# 1. Copies .env-example.xcconfig to .env.xcconfig if .env.xcconfig does not exist
# 2. Reads env vars from .env.xcconfig
# 3. Exports env vars

if [ $ACTION = "indexbuild" ]; then exit 0; fi

echo "EnvironmentVars Export"

CONFIGURATION_PATH="${SRCROOT}/PexelApp-iOS/Configuration/EnvironmentVars"
TEMPLATE_PATH="${CONFIGURATION_PATH}/EnvironmentVars.stencil"

# Path to the env.xcconfig file
xcconfig_file="${CONFIGURATION_PATH}/env.xcconfig"

if ! [ -f "$xcconfig_file" ]; then
    echo "The file '$xcconfig_file' does not exist. Run 'env_vars_init.sh' first."
    exit 1;
fi

echo "Performing EnvironmentVars Export..."

# Read each line from the xcconfig file
while IFS= read -r line; do
  # Ignore comments and empty lines
  if [[ "$line" =~ ^\s*# ]] || [[ -z "$line" ]]; then
    continue
  fi

  # Extract the variable name and value from the line
  var_name="$(echo "$line" | cut -d'=' -f1 | sed 's/ //g')"
  var_value="$(echo "$line" | cut -d'=' -f2- | sed 's/^ *//;s/ *$//;s/^"\(.*\)"$/\1/')"
  export "$var_name"="$var_value"
done < "$xcconfig_file"

echo "EnvironmentVars Exported."
