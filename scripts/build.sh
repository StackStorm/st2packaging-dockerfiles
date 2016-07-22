#!/bin/bash

set -e

export IN_BUILD=true
export BUILD_FILE="$1"
export CONTAINER_FILE="$2"

if [ "$1" == "" ] || [ "$2" == "" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  echo -e "Supply path to build config and container config."
  echo -e "Note that the build config variables will be accessible."
  echo -e "from the container config."
  echo -e "Also, templating is handled via this script as well.\nEx:"
  echo -e "\n$ scripts/build.sh scripts/ubuntu_trusty_build.sh scripts/st2_1.5.1-4_conf.sh\n"
  exit 0
fi

copy_entrypoint_wrapper(){
  echo -e "Copying entrypoint-wrapper/entrypoint-wrapper.sh to $1"
  cp entrypoint-wrapper/entrypoint-wrapper.sh $1
  chmod +x $1/entrypoint-wrapper.sh
}
export -f copy_entrypoint_wrapper

docker_build() {
  echo "########## $1"
  copy_entrypoint_wrapper $1 
  if [ "$1" == "$STAGE1" ] && [ -n "$STAGE2" ]; then
    echo -e "Tagging as intermediate container."
    EXTRA_TAG="-t $INTERMEDIATE_CONTAINER"
  else
    EXTRA_TAG=""
  fi
  echo -e "\nStarting build for: $1\n"
  sudo docker build -t $CONTAINER_OWNER/$1:$BUILD_TAG $EXTRA_TAG $1
  echo -e "\nEnding build for: $1\n"
}
export -f docker_build

check_cache() {
  CACHE_DIR="$1"
  CACHE_PACKAGE="$2"
  LOCATION_VAR="$3"
  LOCATION=${!LOCATION_VAR}

  if [ "$CACHE_DOWNLOAD" == "true" ]; then
    echo -e "\nUsing download cache for: ${LOCATION} \n"
    if [ ! -e "$CACHE_DIR/$CACHE_PACKAGE" ]; then
      echo -e "\nDownloading $CACHE_PACKAGE \n"
      wget -O $CACHE_DIR/$CACHE_PACKAGE $LOCATION
    fi
    export `echo $LOCATION_VAR`=$CACHE_PACKAGE
  fi
}
export -f check_cache

source $BUILD_FILE
source $CONTAINER_FILE

source ./scripts/template.sh $1 $2

TARGET=$STAGE1
for container in $TARGET; do
  docker_build "$container"
done

TARGET=$STAGE2
for container in $TARGET; do
  docker_build "$container"
done

exit 0


