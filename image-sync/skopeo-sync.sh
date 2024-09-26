#!/bin/bash

set -e

# Read the image list file
IMAGES_FILE=$1

# Username and password for the target registry
DEST_USERNAME=$2
DEST_PASSWORD=$3

# Check if username and password are empty
if [ -z "$DEST_USERNAME" ]; then
    echo "Error: DEST_USERNAME is empty"
    exit 1
fi

if [ -z "$DEST_PASSWORD" ]; then
    echo "Error: DEST_PASSWORD is empty"
    exit 1
fi

# Read the mirror list file line by line and synchronize the mirror
while read IMAGE || [[ -n $IMAGE ]]; do
  SOURCE_IMAGE=$(echo $IMAGE | awk '{gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, ""); print}' | awk '{print $1}')
  DEST_IMAGE=$(echo $IMAGE | awk '{gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, ""); print}' | awk '{print $2}')
  echo "======================================================================================================================================="
  echo "Syncing $SOURCE_IMAGE to $DEST_IMAGE"
  skopeo copy --dest-creds $DEST_USERNAME:$DEST_PASSWORD docker://$SOURCE_IMAGE docker://$DEST_IMAGE
done < "$IMAGES_FILE"