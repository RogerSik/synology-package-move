#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

SOURCE_VOLUME=$1
DEST_VOLUME=$2
APPSTORE_DIR="/$SOURCE_VOLUME/@appstore"

# Prompt the user to confirm the completion
read -p "Are you sure you want to move ALL packages FROM $SOURCE_VOLUME to $DEST_VOLUME? (y/n): " -n 1 -r
echo    # Move to a new line after user input

if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Starting Package move"

  for PACKAGE_PATH in "$APPSTORE_DIR"/*; do
    # Extract the package name from the path
    PACKAGE_NAME=$(basename "$PACKAGE_PATH")

    echo "Stop the package $PACKAGE_NAME"
    synopkg stop "$PACKAGE_NAME"

  # Loop through the directories and perform the required actions
  for DIR in appstore appconf appdata apphome appshare apptemp; do
    mv "/$SOURCE_VOLUME/@$DIR/$PACKAGE_NAME" "/$DEST_VOLUME/@$DIR/$PACKAGE_NAME"
    rm -f "/var/packages/$PACKAGE_NAME/${DIR%temp*}"  # Removing 'temp' from the symlink path
    ln -s "/$DEST_VOLUME/@$DIR/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/${DIR%temp*}"
  done

    echo "Start the package $PACKAGE_NAME"
    synopkg start "$PACKAGE_NAME"
  done

else
  echo "Glad i asked"
fi
