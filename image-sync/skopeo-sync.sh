#!/bin/bash

set -e

# 读取镜像列表文件
IMAGES_FILE=$1

# 目标注册表的用户名和密码
DEST_USERNAME=$2
DEST_PASSWORD=$3

# 逐行读取镜像列表文件并同步镜像
while IFS= read -r IMAGE; do
  SOURCE_IMAGE=$(echo $IMAGE | awk '{print $1}')
  DEST_IMAGE=$(echo $IMAGE | awk '{print $2}')
  echo "Syncing $SOURCE_IMAGE to $DEST_IMAGE"
  echo $DEST_PASSWORD | skopeo copy --dest-creds $DEST_USERNAME:$(cat) docker://$SOURCE_IMAGE docker://$DEST_IMAGE
done < "$IMAGES_FILE"