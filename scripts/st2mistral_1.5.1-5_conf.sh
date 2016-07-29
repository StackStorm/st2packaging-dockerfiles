export PACKAGECLOUD_URL="https://packagecloud.io/StackStorm"

export ST2MISTRAL_VERSION="1.5.1-5"
export ST2MISTRAL_REPO="stable"
export ST2MISTRAL_PACKAGE="${PACKAGECLOUD_URL}/${ST2MISTRAL_REPO}/packages/ubuntu/trusty/st2mistral_${ST2MISTRAL_VERSION}_amd64.deb/download"

export CONTAINER_OWNER="stackstorm"
export BUILD_TAG="${ST2MISTRAL_VERSION}_$(echo $BASE_DISTRO | tr ':' '_')"
export CACHE_DOWNLOAD=true

export STAGE1="mistral_base"
export STAGE2="mistral_api mistral_server"
export CONTAINERS="$STAGE1 $STAGE2"

export INTERMEDIATE_CONTAINER="${CONTAINER_OWNER}/${STAGE1}_build:${BUILD_TAG}"

check_cache "mistral_base" "st2mistral_${ST2MISTRAL_VERSION}_amd64.deb" ST2MISTRAL_PACKAGE

export DUMB_INIT_VERSION="1.0.3"
export DUMB_INIT_PACKAGE="https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb"

export CONFD_VERSION="0.11.0"
export CONFD_BINARY="https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64"

check_cache "mistral_base" "dumb-init.deb" DUMB_INIT_PACKAGE
check_cache "mistral_base" "confd" CONFD_BINARY
