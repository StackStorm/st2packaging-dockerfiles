export BASE_DISTRO="ubuntu:trusty"
export INTERMEDIATE_CONTAINER="stackstorm/stackstorm:build"


export ST2_VERSION="1.5.1-4"
export ST2_REPO=stable
export ST2_PACKAGE="https://packagecloud.io/StackStorm/${ST2_REPO}/packages/ubuntu/trusty/st2_${ST2_VERSION}_amd64.deb/download"

export CONTAINER_OWNER="stackstorm"
export BUILD_TAG="${ST2_VERSION}_$(echo $BASE_DISTRO | tr ':' '_')"
export CACHE_DOWNLOAD=true

export CONTAINERS="stackstorm client data st2actionrunner st2api st2auth \
st2exporter st2garbagecollector st2notifier st2resultstracker \
st2rulesengine st2sensorcontainer st2stream"
export STAGE1="stackstorm"
export STAGE2="client data st2actionrunner st2api st2auth st2exporter st2garbagecollector \
st2notifier st2resultstracker st2rulesengine st2sensorcontainer st2stream"

