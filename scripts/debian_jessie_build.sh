export BASE_DISTRO="debian:jessie"

export ADD_SOURCE_LIST="ADD ./sources.list /etc/apt"

export UPDATE_AND_UPGRADE="apt-get -y update && apt-get -y upgrade"
export CLEAN_PACKAGES="apt-get clean"
export INSTALL_PACKAGE="apt-get -y install"
export REMOVE_PACKAGE="apt-get -y rm"
