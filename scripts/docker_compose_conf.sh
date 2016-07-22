
export ST2_VERSION="1.5.1-4"
export ST2WEB_VERSION="1.5.1-1"

export CONTAINER_OWNER="stackstorm"

export BASE_DISTRO_TAG="$(echo $BASE_DISTRO | tr ':' '_')"

export STAGE1="docker_compose"
export STAGE2=""
export CONTAINERS="$STAGE1 $STAGE2"


export HOST_IP="192.168.50.10"
export ST2_WEB_HOST="$HOST_IP"
export ST2_WEB_PORT="8443"
# options are: single-host, distributed, and rancher
export CONTAINER_ENV="distributed"
# options are: volume, http-tar, and git
# export DATASTORE_TYPE="volume"
export DATASTORE_TYPE="http-tar"
export BASE_DATASTORE_HTTP_ADDRESS="http://${HOST_IP}:8000/"
export ST2_DATASTORE_HTTP_ADDRESS="$BASE_DATASTORE_HTTP_ADDRESS/st2.tar.gz"
export ST2WEB_DATASTORE_HTTP_ADDRESS="$BASE_DATASTORE_HTTP_ADDRESS/st2web.tar.gz"
