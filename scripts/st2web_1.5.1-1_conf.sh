
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
