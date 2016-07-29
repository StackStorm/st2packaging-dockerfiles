#!/bin/sh

# $VOLUMES_DIR is given for running

set -e

export ST2_API_HOST="st2api"
export ST2_AUTH_HOST="st2auth"
export ST2_STREAM_HOST="st2stream"

echo "Copying over nginx.conf"
cp $DATA_VOLUMES_DIR/st2web/nginx.conf /etc/nginx/nginx.conf

echo "Running confd"
$DATA_VOLUMES_DIR/tooling/confd -onetime -backend env -confdir $DATA_VOLUMES_DIR/st2web/confd
