#!/bin/bash
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
WINDOWS="$CURRENT_DIR/export/cool_shoot.exe"
LINUX="$CURRENT_DIR/export/cool_shoot.x86_64"

echo Uploading to Itch...
butler -v push "$WINDOWS" "samsarette/cool-shoot:windows"
butler -v push "$LINUX" "samsarette/cool-shoot:linux"

echo Done.
