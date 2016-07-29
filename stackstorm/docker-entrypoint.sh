#!/bin/bash

# We expect docker links with default names: rabbitmq, mongo
export RABBITMQ_URL="${AMQP_URL:-amqp://guest:guest@rabbitmq:5672/}"
export MONGO_HOST="${DB_HOST:-mongo}"
export MONGO_PORT="${DB_PORT:-27017}"
export ST2_API_URL="https://${PUBLIC_ADDRESS}/api/"

# Check *_PORT variable if container is linked
linked_service() { [[ "$1" != tcp://* ]] && return 1; return 0; }

# We found docker linked st2 api env var
# if (linked_service "$API_PORT"); then
#   api_url="http://${API_PORT#tcp://}"
# fi


if [ -z $ST2_SERVICE ]; then
  [ $# -gt 0 ] && exec "$@" || exec /bin/bash
else
  CMDARGS="${@:---config-file /etc/st2/st2.conf}"
  echo -e "running: /opt/stackstorm/st2/bin/$ST2_SERVICE $CMDARGS"
  /opt/stackstorm/st2/bin/$ST2_SERVICE $CMDARGS
fi
