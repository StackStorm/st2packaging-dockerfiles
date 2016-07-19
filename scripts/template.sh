#!/bin/bash

set -e

BUILD_FILE="$1"
CONTAINER_FILE="$1"

if [ "$IN_BUILD" != "true" ]; then
  if [ "$1" == "" ] || [ "$2" == "" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
    echo -e "Supply path to build config and container config."
    echo -e "Note that the build config variables will be accessible."
    echo -e "from the container config.\nEx:"
    echo -e "\n$ scripts/template.sh scripts/ubuntu_trusty_build.sh scripts/st2_1.5.1-4_conf.sh\n"
    exit 0
  fi
  source $CONF_FILE
fi



FILE=$CONTAINERS

for entry in $FILE; do
  echo "Evaluating template: $entry/Dockerfile.template"
  envsubst < $entry/Dockerfile.template > $entry/Dockerfile
done
