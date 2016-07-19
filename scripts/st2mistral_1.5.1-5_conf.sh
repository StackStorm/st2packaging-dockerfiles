export PACKAGECLOUD_URL="https://packagecloud.io/StackStorm"

export ST2MISTRAL_VERSION="1.5.1-5"
export ST2MISTRAL_REPO="stable"
export ST2MISTRAL_PACKAGE="${PACKAGECLOUD_URL}/${ST2MISTRAL_REPO}/packages/ubuntu/trusty/st2mistral_${ST2MISTRAL_VERSION}_amd64.deb/download"

export CONTAINER_OWNER="stackstorm"
export BUILD_TAG="${ST2MISTRAL_VERSION}_$(echo $BASE_DISTRO | tr ':' '_')"
export CACHE_DOWNLOAD=true

export CONTAINERS="st2mistral"
export STAGE1="st2mistral"
export STAGE2=""

check_cache "st2mistral" "st2mistral_${ST2MISTRAL_VERSION}_amd64.deb" ST2MISTRAL_PACKAGE
