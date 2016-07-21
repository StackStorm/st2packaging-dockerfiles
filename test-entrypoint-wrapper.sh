export CONTAINER_ENV="single-host"
export DATASTORE_TYPE="volume"
export HOST_IP="192.168.50.10"
export DATASTORE_DIR=`pwd`/datastore_example
export CONFD_HOST_DIR=`pwd`/test_confd_host_dir
#DATASTORE_CONFD_DIR=

source ./entrypoint-wrapper.sh
