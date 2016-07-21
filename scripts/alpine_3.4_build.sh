export BASE_DISTRO="alpine:3.4"

export UPDATE_AND_UPGRADE="apk -y update && apk -y upgrade"
export CLEAN_PACKAGES="apk cache clean"
export INSTALL_PACKAGE="apk --update add"
export REMOVE_PACKAGE="apk del"
