set -e

COMPONENT="$1"
VERSION="$2"
PULL_DIR="$3"
COMMAND="$4"

HOST_IP="192.168.50.10"
NAME="--name test-st2web"
IMAGE="rancher-m.lan/stackstorm/${COMPONENT}:${VERSION}_ubuntu_trusty"
#PORTS="-p 8443:443"
ENV="-e HOST_IP=$HOST_IP -e CONTAINER_ENV=single-host -e DATASTORE_TYPE=http-tar -e DATASTORE_HTTP_ADDRESS=http://$HOST_IP:8000/${PULL_DIR}.tar.gz"

DOCKER_CMD="sudo docker run --rm -it $NAME $PORTS $ENV $IMAGE $COMMAND"
echo "$DOCKER_CMD"
eval "$DOCKER_CMD"
