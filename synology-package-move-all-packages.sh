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

    # appstore
    mv "/$SOURCE_VOLUME/@appstore/$PACKAGE_NAME"  "/$DEST_VOLUME/@appstore/$PACKAGE_NAME"
    rm -f "/var/packages/$PACKAGE_NAME/target"
    ln -s "/$DEST_VOLUME/@appstore/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/target"

    # appconf
    mv "/$SOURCE_VOLUME/@appconf/$PACKAGE_NAME" "/$DEST_VOLUME/@appconf/$PACKAGE_NAME"
    rm -f "/var/packages/$PACKAGE_NAME/etc"
    ln -s "/$DEST_VOLUME/@appconf/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/etc"

    #
    mv "/$SOURCE_VOLUME/@appdata/$PACKAGE_NAME" "/$DEST_VOLUME/@appdata/$PACKAGE_NAME"
    rm -f "/var/packages/$PACKAGE_NAME/var"
    ln -s "/$DEST_VOLUME/@appdata/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/var"

    #
    mv "/$SOURCE_VOLUME/@apphome/$PACKAGE_NAME" "/$DEST_VOLUME/@apphome/$PACKAGE_NAME"
    rm -f "/var/packages/$PACKAGE_NAME/home"
    ln -s "/$DEST_VOLUME/@apphome/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/home"

    #
    mv "/$SOURCE_VOLUME/@appshare/$PACKAGE_NAME" "/$DEST_VOLUME/@appshare/$PACKAGE_NAME"
    rm -f "/var/packages/$PACKAGE_NAME/share"
    ln -s "/$DEST_VOLUME/@appshare/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/share"

    #
    mv "/$SOURCE_VOLUME/@apptemp/$PACKAGE_NAME" "/$DEST_VOLUME/@apptemp/$PACKAGE_NAME"
    rm -f "/var/packages/$PACKAGE_NAME/tmp"
    ln -s "/$DEST_VOLUME/@apptemp/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/tmp"

    echo "Start the package $PACKAGE_NAME"
    synopkg start "$PACKAGE_NAME"
  done

else
  echo "Glad i asked"
fi
