#!/bin/bash

# Check if the parameter is provided
if [ -z "$1" ]; then
  echo "Please provide following arguments:"
  echo "package_name source_volume destination_volume"
  echo "Example ./package-move.sh HyperBackup volume1 volume2"
  exit 1
fi

PACKAGE_NAME=$1
SOURCE_VOLUME=$2
DEST_VOLUME=$3

read -p "Did you stopped $PACKAGE_NAME in Synology package centrum? (y/n): " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Move package from $SOURCE_VOLUME to $DEST_VOLUME"
    mv "/$SOURCE_VOLUME/@appstore/$PACKAGE_NAME" "/$DEST_VOLUME/@appstore/$PACKAGE_NAME"

    echo "Remove the existing target"
    rm -f "/var/packages/$PACKAGE_NAME/target"

    echo "Create a symbolic link to the new location"
    ln -s "/$DEST_VOLUME/@appstore/$PACKAGE_NAME" "/var/packages/$PACKAGE_NAME/target"

  echo "Package operations completed."
else
  echo "Package operations not confirmed. Please ensure that the package is stopped in package centrum."
fi


