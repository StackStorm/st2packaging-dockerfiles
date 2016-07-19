#!/bin/bash

set -e

CONF_FILE="conf.sh"

if [ "$IN_BUILD" != "true" ]; then
  source $CONF_FILE
fi


FILE=$1

if [ "$FILE" == "" ] || [ "$FILE" == "-h" ] || [ "$FILE" == "--help" ] ; then
  echo "Supply directory to eval Docker.template file or \"-a\" to do all in config"
  exit 0
fi
if [ "$FILE" == "-a" ]; then
  echo "ALL detected"
  FILE=$CONTAINERS
fi

for entry in $FILE; do
  echo "Evaluating template: $entry/Dockerfile.template"
  envsubst < $entry/Dockerfile.template > $entry/Dockerfile
done
