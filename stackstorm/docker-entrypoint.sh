#!/bin/bash

# We expect docker links with default names: rabbitmq, mongo
amqp_host="${AMQP_HOST:-rabbitmq}"
amqp_port="${AMQP_PORT:-5672}"
amqp_user="${AMQP_USER:-guest}"
amqp_password="${AMQP_PASSWORD:-guest}"
amqp_url="amqp://$amqp_user:$amqp_password@$amqp_host:$amqp_port/"

if [ -n $ST2_REQUIRE_AMQP ]; then
  until nc -z $amqp_host $amqp_port; do
    echo "AMQP at $amqp_host:$amqp_port doesn't respond. Waiting..."
    sleep 1
  done
fi

db_host="${DB_HOST:-mongo}"
db_port="${DB_PORT:-27017}"

if [ -n $ST2_REQUIRE_DB ]; then
  until nc -z $db_host $db_port; do
    echo "DB at $db_host:$db_port doesn't respond. Waiting..."
    sleep 1
  done
fi

# Check *_PORT variable if container is linked
linked_service() { [[ "$1" != tcp://* ]] && return 1; return 0; }

# Generate config file
generate_config_file() {
  # Configuration has been already altered, so skip generation!
  (md5sum --quiet -c /st2.conf.orig.md5) || return 0

  cat /st2.conf.template | \
    sed -e "s|\$\$api_url|$api_url|" \
        -e "s|\$\$db_host|$db_host|" \
        -e "s|\$\$db_port|$db_port|" \
        -e "s|\$\$amqp_url|$amqp_url|" > /etc/st2/st2.conf
}

# We found docker linked st2 api env var
if (linked_service "$API_PORT"); then
  api_url="http://${API_PORT#tcp://}"
fi

generate_config_file

if [ -z $ST2_SERVICE ]; then
  [ $# -gt 0 ] && exec "$@" || exec /bin/bash
else
  CMDARGS="${@:---config-file /etc/st2/st2.conf}"
  /opt/stackstorm/st2/bin/$ST2_SERVICE $CMDARGS
fi
