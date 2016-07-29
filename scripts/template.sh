#!/bin/bash

set -e

BUILD_FILE="$1"
CONTAINER_FILE="$2"

if [ "$IN_BUILD" != "true" ]; then
  if [ "$1" == "" ] || [ "$2" == "" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
    echo -e "Supply path to build config and container config."
    echo -e "Note that the build config variables will be accessible."
    echo -e "from the container config.\nEx:"
    echo -e "\n$ scripts/template.sh scripts/ubuntu_trusty_build.sh scripts/st2_1.5.1-4_conf.sh\n"
    exit 0
  fi
  source $BUILD_FILE
  source $CONTAINER_FILE
fi



DIRECTORIES="$CONTAINERS"

for directory in $DIRECTORIES; do
  DOCKERFILE="$directory/Dockerfile"
  DOCKER_COMPOSE="$directory/docker-compose.yml"
  
  if [ -e ${DOCKERFILE}.template ]; then 
    echo "Evaluating template: ${DOCKERFILE}.template"
    envsubst < ${DOCKERFILE}.template > $DOCKERFILE
  fi

  if [ -e ${DOCKER_COMPOSE}.template ]; then 
    echo "Evaluating template: ${DOCKER_COMPOSE}.template"
    envsubst < ${DOCKER_COMPOSE}.template > $DOCKER_COMPOSE
  fi

done
