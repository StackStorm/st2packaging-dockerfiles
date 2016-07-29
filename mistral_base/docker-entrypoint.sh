#!/bin/bash

# We expect docker links with default names: rabbitmq, mongo
amqp_url="${AMQP_URL:-amqp://guest:guest@rabbitmq:5672/}"
postgres_host="${DB_HOST:-postgres}"
postgres_port="${DB_PORT:-5432}"

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
