#!/bin/bash

# This script should be run as a phase script before building the project
#
# The script:
# 1. Runs swiftgen to generate L10n and Assets structs

# Don't run this during index builds
if [ $ACTION = "indexbuild" ]; then exit 0; fi

source "$PROJECT_DIR/PexelApp-Tooling/Scripts/env_vars_export.sh"

SWIFTGEN_PATH="$PROJECT_DIR/PexelApp-Tooling/SwiftGen/swiftgen"

if [ "$SKIP_STRINGS_AND_ASSETS_CODEGEN" == "YES" ]
then
  echo "Skipping SwiftGen script. Turn env var 'SKIP_STRINGS_AND_ASSETS_CODEGEN' to `NO` if needed."
  exit 0;
fi

SWIFTGEN_CONFIG_PATH=$SRCROOT/Packages/ResourcesCatalog/Sources/ResourcesCatalog/Configuration/swiftgen.yml

if [[ -f "$SWIFTGEN_PATH" ]]; then
        "$SWIFTGEN_PATH" config run --config $SWIFTGEN_CONFIG_PATH
else
  echo "warning: SwiftGen is missing."
fi
