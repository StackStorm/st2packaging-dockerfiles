#!/bin/bash

set -e

export CONF_FILE="conf.sh"
source $CONF_FILE
export IN_BUILD=true

docker_build() {
  echo "########## $1"
  if [ "$container" == "stackstorm" ]; then
    EXTRA_TAG="-t $CONTAINER_OWNER/$1:build"
  fi
  echo -e "\nStarting build for: $1\n"
  sudo docker build -t $CONTAINER_OWNER/$1:$BUILD_TAG $EXTRA_TAG $1
  echo -e "\nEnding build for: $1\n"
}

export -f docker_build

parallel_build() {
  echo -e "\nStarting parallel build...\n"
  echo "$1" | tr " " "\n" | parallel --no-notice --pipe cat 
  parallel --no-notice docker_build ::: $1
}

TARGET=$1


export CACHE_DIR="stackstorm"
export CACHE_ST2_PACKAGE="st2_${ST2_VERSION}_amd64.deb"

if [ "$CACHE_DOWNLOAD" == "true" ]; then
  echo -e "\nUsing download cache\n"
  if [ ! -e "$CACHE_DIR/$CACHE_ST2_PACKAGE" ]; then
    echo -e "\nDownloading $ST2_PACKAGE \n"
    wget -O $CACHE_DIR/$CACHE_ST2_PACKAGE $ST2_PACKAGE
  fi
  export ST2_PACKAGE=$CACHE_ST2_PACKAGE
fi

source ./template.sh $1

if [ "$1" == "-a" ]; then
  TARGET=$STAGE1
  echo "$TARGET"
  parallel_build "$TARGET" 
  TARGET=$STAGE2
  parallel_build "$TARGET" 
  exit 0
fi

for container in $TARGET; do
  docker_build "$container"
done

