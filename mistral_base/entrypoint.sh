#!/bin/bash

# We expect docker links with default names: rabbitmq, mongo
export RABBITMQ_URL="${AMQP_URL:-amqp://guest:guest@rabbitmq:5672/}"
export MONGO_HOST="${DB_HOST:-mongo}"
export MONGO_PORT="${DB_PORT:-27017}"
export ST2_API_URL="https://${PUBLIC_ADDRESS}/api/"

run_confd

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

case $MISTRAL_SERVICE in
  "")
    [ $# -gt 0 ] && exec "$@" || exec /bin/bash
    ;;
  "mistral_api")  
    PID_FILE="/var/run/mistral/mistral-api.pid"
    S_S_DAEMON_ARGS="--start --chuid mistral:mistral --umask 022 --make-pidfile --pidfile $PID_FILE"
    PROCESS="/opt/stackstorm/mistral/bin/gunicorn"
    PROCESS_ARGS_DEFAULT="--log-file /var/log/mistral/mistral-api.log -b 127.0.0.1:8989 -w 2 mistral.api.wsgi --graceful-timeout 10 --pid /var/run/mistral/mistral-api.pid"
    PROCESS_ARGS=${@:-"$PROCESS_ARGS_DEFAULT"}
    run_process "$S_S_DAEMON_ARGS" "$PROCESS" "$PROCESS_ARGS" 
    ;;
  "mistral_server")  
    PID_FILE="/var/run/mistral/mistral-server.pid"
    S_S_DAEMON_ARGS="--start --chuid mistral:mistral --umask 022 --make-pidfile --pidfile $PID_FILE"
    PROCESS="/opt/stackstorm/mistral/bin/mistral-server"
    PROCESS_ARGS_DEFAULT="--server engine,executor --config-file /etc/mistral/mistral.conf --log-file /var/log/mistral/mistral-server.log"
    PROCESS_ARGS=${@:-"$PROCESS_ARGS_DEFAULT"}
    run_process "$S_S_DAEMON_ARGS" "$PROCESS" "$PROCESS_ARGS" 
    ;;
  *)
    echo "env var MISTRAL_SERVER set to unknown value of $MISTRAL_SERVICE"
    ;;
esac
