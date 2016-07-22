
set -e 
echo -e "Starting test-entrypoint-wrapper.sh"

echo -e "\nSTEP 1: set env vars\n"

DATASTORE_EXAMPLE_DIR=`pwd`/datastore_example
DATASTORE_TARGET=`pwd`/datastore_target

#export ST2_API_URL=
export DATASTORE_DIR="$DATASTORE_TARGET"

# options are: single-host, distributed, and rancher
export CONTAINER_ENV="single-host"
# options are: volume, http-tar, and git
# export DATASTORE_TYPE="volume"

export HOST_IP="192.168.50.10"

export DATASTORE_DIR=$DATASTORE_TARGET
export ENTRYPOINT_FILE=`pwd`/fake-entrypoint.sh
# only if using rancher
export METADATA_IP=
export HOST_IP_PATH="2015-12-19/self/host/agent_ip"

# directory inside of datastore where confd data is saved
# export DATASTORE_CONFD_DIR="confd"
export CONFD_HOST_DIR=`pwd`/test_confd_host_dir

#DATASTORE_CONFD_DIR=

export INSIDE_DUMB_INIT="true"


echo -e "\nSTEP 2: testing with regular volume \n"
rm -rf $DATASTORE_TARGET/* || :
cp -r $DATASTORE_EXAMPLE_DIR/* $DATASTORE_TARGET

export DATASTORE_TYPE="volume"

source ./entrypoint-wrapper.sh

echo -e "\nSTEP 3: create tar of ${DATASTORE_EXAMPLE_DIR}\n"
tar -czf ${DATASTORE_EXAMPLE_DIR}.tar.gz -C $DATASTORE_EXAMPLE_DIR .



echo -e "\nSTEP 4: starting python3 -m http.server\n"
python3 -m http.server &
export PYTHON_PID=$!
echo -e "Python server pid: ${PYTHON_PID}"
sleep 1

clean_exit() {
  echo -e "Attempting to end python server with: kill $PYTHON_PID"
  kill $PYTHON_PID
}
export -f clean_exit

trap clean_exit EXIT

echo -e "\nSTEP 5: testing with tar over http\n"
rm -rf $DATASTORE_TARGET/* || :

export DATASTORE_TYPE="http-tar"
export DATASTORE_HTTP_ADDRESS="http://localhost:8000/datastore_example.tar.gz"
source ./entrypoint-wrapper.sh

echo -e "\nFINISHED WITH ALL EXAMPLES WORKING!\n"

exit 0
