set -e

echo "Staring entrypoint-wrapper.sh"

NEEDED_VARS="CONTAINER_ENV DATASTORE_TYPE DATASTORE_DIR HOST_IP PUBLIC_ADDRESS \
  DATASTORE_CONFD_DIR ENTRYPOINT_FILE CONFD_HOST_DIR"

export ENTRYPOINT_FILE="${ENTRYPOINT_FILE:-/entrypoint.sh}"
export METADATA_IP="rancher-metadata.rancher.internal"
export HOST_IP_PATH="2015-12-19/self/host/agent_ip"

# options are: single-host, distributed, and rancher
export CONTAINER_ENV="${CONTAINER_ENV:-single-host}"
# options are: volume, http-tar, and git
export DATASTORE_TYPE="${DATASTORE_TYPE:-volume}"
export DATASTORE_DIR="/${DATASTORE_DIR:-/datastore_pull}"
export DATASTORE_CONFD_DIR="${DATASTORE_CONFD_DIR:-confd}"
export CONFD_DIR="$DATASTORE_DIR/$DATASTORE_CONFD_DIR"
export CONFD_HOST_DIR="/${CONFD_HOST_DIR:-/etc/confd}"

if [ "$CONTAINER_ENV" == "rancher" ]; then
  verify_installed curl
  export HOST_IP=`curl ${METADATA_IP}/${HOST_IP_PATH}`
fi
export PUBLIC_ADDRESS="${PUBLIC_ADDRESS:-$HOST_IP}"


verify_installed() {
  PROGRAM=$1
  command -v $PROGRAM >/dev/null 2>&1 || { echo >&2 "Require $PROGRAM but it's not installed.  Aborting."; exit 1; }
  echo "Verified that $PROGRAM is installed."
}
export -f verify_installed

verify_vars_exist() {
  for var in $1 ; do
    if [ -n "${!var}" ]; then
      echo "env var ${var}=${!var}"
    else
      echo "ERROR: env var ${var} is not defined but needed for startup script!"
      echo "exiting..."
      exit 1
    fi
  done
}
export -f verify_vars_exist

if [ "$DATASTORE_TYPE" != "volume" ]; then
  echo -e "Detected remote datastore type '$DATASTORE_TYPE', starting to retrieve datastore..."
  export NEEDED_VARS="$NEEDED_VARS DATASTORE_DIR"
  echo -e "Creating datastore dir (will 'rm -rf' prior dir): $DATASTORE_DIR"
  rm -rf $DATASTORE_DIR
  mkdir ${DATASTORE_DIR}
  case $DATASTORE_TYPE in
    git)
      export NEEDED_VARS="$NEEDED_VARS DATASTORE_GIT_ADDRESS DATASTORE_GIT_BRANCH"
      verify_vars_exist "$NEEDED_VARS"
      verify_installed git
      echo -e "Git cloning git repo:\n\tgit address: $DATASTORE_GIT\n\tbranch: $DATASTORE_GIT_BRANCH\n\tclone dir: $DATASTORE_DIR"
      git clone --branch $DATASTORE_GIT_BRANCH $DATASTORE_GIT_ADDRESS $DATASTORE_DIR
      if [ -n "$DATASTORE_GIT_COMMIT" ]; then
        echo -e "Checking out commit: $DATASTORE_GIT_COMMIT"
        (cd $DATASTORE_DIR; git checkout $DATASTORE_GIT_COMMIT)
      fi
    ;;
    http-tar)
      export NEEDED_VARS="$NEEDED_VARS DATASTORE_HTTP_ADDRESS"
      verify_vars_exist "$NEEDED_VARS"
      verify_installed curl tar
      TMP_DATASTORE_PATH="/tmp/DATASTORE_PULL.tar.gz"
      echo -e "curl downlading: $DATASTORE_HTTP_ADDRESS"
      curl -L $DATASTORE_HTTP_ADDRESS --output $TMP_DATASTORE_PATH
      echo -e "extracting files (tar xzf)"
      tar xzf $TMP_DATASTORE_PATH -C $DATASTORE_DIR 
  esac
  echo -e "Finished retrieving datastore."
else
  verify_vars_exist "$NEEDED_VARS"
fi

echo "Running confd templating"
verify_installed confd
echo "Adding confd files from datastore to system files"
mkdir -p $CONFD_HOST_DIR/{conf.d,templates}
cp -r $CONFD_DIR/conf.d/* $CONFD_HOST_DIR/conf.d/ || :
cp -r $CONFD_DIR/templates/* $CONFD_HOST_DIR/templates/ || :

echo "Running condf -onetime -backend env -confdir $CONFD_HOST_DIR"
confd -onetime -backend env -confdir $CONFD_HOST_DIR

if [ -s "$DATASTORE_DIR/file_copy.sh" ]; then
  echo "Running file_copy.sh in from datastore"
  source $DATASTORE_DIR/file_copy.sh
else
  echo "No file_copy.sh found in datastore"
fi

verify_installed dumb-init

if [ "$INSIDE_DUMB_INIT" != "true" ]; then
  echo -e "Detected that entrypoint isn't wrapped in dumb-init!!!"
  echo -e "Make sure that entrypoint is: export INSIDE_DUMB_INIT=\"true\"; dumb-init /entrypoint-wrapper.sh"
  exit 1
fi
echo "entrypoint-wrapper.sh finished, sourcing entrypoint.sh"

source $ENTRYPOINT_FILE
