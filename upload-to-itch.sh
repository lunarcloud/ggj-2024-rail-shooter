#!/bin/bash
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
WINDOWS="$CURRENT_DIR/export/cool_shoot.exe"
LINUX="$CURRENT_DIR/export/cool_shoot.x86_64"
MACOS="$CURRENT_DIR/export/cool_shoot.zip"
ANDROID="$CURRENT_DIR/export/cool_shoot.apk"
WEB="$CURRENT_DIR/export/web"

echo Uploading to Itch...
butler -v push "$WINDOWS" "samsarette/cool-shoot:windows"
butler -v push "$LINUX" "samsarette/cool-shoot:linux"
butler -v push "$MACOS" "samsarette/cool-shoot:mac"
#butler -v push "$ANDROID" "samsarette/cool-shoot:android"
#butler -v push "$WEB" "samsarette/cool-shoot:web"

echo Done.
