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
