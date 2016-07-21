export ST2_VERSION="1.5.1"

export CONTAINER_OWNER="stackstorm"
export BUILD_TAG="${ST2_VERSION}_$(echo $BASE_DISTRO | tr ':' '_')"
export CACHE_DOWNLOAD=false

export CONTAINERS="data"
export STAGE1="data"
export STAGE2=""



