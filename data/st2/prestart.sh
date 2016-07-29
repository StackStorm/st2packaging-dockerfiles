#!/bin/sh

# $VOLUMES_DIR is given for running

set -e

export RABBITMQ_URL="${AMQP_URL:-amqp://guest:guest@rabbitmq:5672/}"
export MONGO_HOST="${DB_HOST:-mongo}"
export MONGO_PORT="${DB_PORT:-27017}"
export ST2_API_URL="https://${PUBLIC_ADDRESS}/api/"

export ST2_API_HOST=$HOST_IP

echo "Copying over htpasswd"
cp $DATA_VOLUMES_DIR/st2/htpasswd /etc/st2/htpasswd

echo "Copying over packs"
for f in `ls -A $DATA_VOLUMES_DIR/st2/packs/`; do
  echo "Copying pack: $f"
  #cp -R $f /opt/stackstorm/packs/
done

echo "Running confd"
$DATA_VOLUMES_DIR/tooling/confd -onetime -backend env -confdir $DATA_VOLUMES_DIR/st2/confd
