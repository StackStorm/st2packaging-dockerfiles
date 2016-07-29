#!/bin/sh

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

run_process() {
  PROCESS_CMD="start-stop-daemon $1 --exec $2 -- $3"
  echo "$PROCESS_CMD"
  eval $PROCESS_CMD
}

if [ "$#" -gt "0" ]; then
  exec "$@"
else
  PID_FILE="/var/run/nginx.pid"
  S_S_DAEMON_ARGS="--start --make-pidfile --pidfile $PID_FILE"
  PROCESS="`which nginx`"
  PROCESS_ARGS_DEFAULT="-g 'daemon off;'"
  PROCESS_ARGS=${@:-"$PROCESS_ARGS_DEFAULT"}
  run_process "$S_S_DAEMON_ARGS" "$PROCESS" "$PROCESS_ARGS" 
fi
