set -e

# options are: single-host, distributed, and rancher
export CONTAINER_ENV="${CONTAINER_ENV:-single-host}"
# options are: volume, http-tar, and git
export DATASTORE_TYPE="${DATASTORE_TYPE:-volume}"

if [ "$CONTAINER_ENV" == "rancher" ]; then
  export IP="rancher"
fi


