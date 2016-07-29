
# Requires BASE_DISTRO variable. Ex: ubuntu:trusty

export PACKAGECLOUD_URL="https://packagecloud.io/StackStorm"

export ST2WEB_VERSION="1.5.1-1"
export ST2WEB_REPO="stable"
export ST2WEB_PACKAGE="${PACKAGECLOUD_URL}/${ST2WEB_REPO}/packages/ubuntu/trusty/st2web_${ST2WEB_VERSION}_amd64.deb/download"

export CONTAINER_OWNER="stackstorm"
export BUILD_TAG="${ST2WEB_VERSION}_$(echo $BASE_DISTRO | tr ':' '_')"
export CACHE_DOWNLOAD=true

export STAGE1="st2web"
export STAGE2=""
export CONTAINERS="$STAGE1 $STAGE2"

check_cache "st2web" "st2web_${ST2WEB_VERSION}_amd64.deb" ST2WEB_PACKAGE

export DUMB_INIT_VERSION="1.0.3"
export DUMB_INIT_PACKAGE="https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb"

export CONFD_VERSION="0.11.0"
export CONFD_BINARY="https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64"

check_cache "st2web" "dumb-init.deb" DUMB_INIT_PACKAGE
check_cache "st2web" "confd" CONFD_BINARY
