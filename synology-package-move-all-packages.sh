#!/bin/bash

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

    echo "Move the package $PACKAGE_NAME to the new location"
    mv "$PACKAGE_PATH" "/$DEST_VOLUME/@appstore/$PACKAGE_NAME"

    echo "Remove the existing target of $PACKAGE_NAME for volume change"
    rm -f "/var/packages/$PACKAGE_NAME/target"

    echo "Create new target of $PACKAGE_NAME which points to $DEST_VOLUME"
    ln -s "/$DEST_VOLUME/@appstore/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/target"

    echo "Start the package $PACKAGE_NAME"
    synopkg start "$PACKAGE_NAME"
  done
else
  echo "Glad i asked"
fi
