
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

export DATA_VOLUMES_DIR="/data_volumes"

export ST2_ENTRYPOINT="$DATA_VOLUMES_DIR/tooling/containerpilot -config file://$DATA_VOLUMES_DIR/st2/containerpilot.json /docker-entrypoint.sh"
export ST2WEB_ENTRYPOINT="$DATA_VOLUMES_DIR/tooling/containerpilot -config file://$DATA_VOLUMES_DIR/st2web/containerpilot.json /docker-entrypoint.sh"
export ST2_ENTRYPOINT_YAML="entrypoint: $ST2_ENTRYPOINT"
export ST2WEB_ENTRYPOINT_YAML="entrypoint: $ST2WEB_ENTRYPOINT"

export CONSUL_HOST="192.168.50.10"

REPO_DIR="`pwd`"

export DATA_TOOLING_VOLUME="$REPO_DIR/data/tooling"
export DATA_ST2CONF_VOLUME="$REPO_DIR/data/st2"
export DATA_MISTRAL_VOLUME="$REPO_DIR/data/st2mistral"
export DATA_ST2WEBCONF_VOLUME="$REPO_DIR/data/st2web"
