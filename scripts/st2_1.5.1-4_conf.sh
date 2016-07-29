export PACKAGECLOUD_URL="https://packagecloud.io/StackStorm"

export ST2_VERSION="1.5.1-4"
export ST2_REPO="stable"
export ST2_PACKAGE="${PACKAGECLOUD_URL}/${ST2_REPO}/packages/ubuntu/trusty/st2_${ST2_VERSION}_amd64.deb/download"

export CONTAINER_OWNER="stackstorm"
export BUILD_TAG="${ST2_VERSION}_$(echo $BASE_DISTRO | tr ':' '_')"
export CACHE_DOWNLOAD=true

export STAGE1="stackstorm"
export STAGE2="client st2actionrunner st2api st2auth st2exporter st2garbagecollector \
st2notifier st2resultstracker st2rulesengine st2sensorcontainer st2stream"
export CONTAINERS="$STAGE1 $STAGE2"

export INTERMEDIATE_CONTAINER="${CONTAINER_OWNER}/${STAGE1}_build:${BUILD_TAG}"

check_cache "stackstorm" "st2_${ST2_VERSION}_amd64.deb" ST2_PACKAGE

export DUMB_INIT_VERSION="1.0.3"
export DUMB_INIT_PACKAGE="https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb"

check_cache "stackstorm" "dumb-init.deb" DUMB_INIT_PACKAGE 

