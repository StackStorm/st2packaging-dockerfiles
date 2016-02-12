FROM centos:7

# Download tools
RUN yum -y install \
    ca-certificates \
    curl \
    wget

# Build tools
RUN yum -y install \
    autoconf \
    automake \
    bzip2 \
    bzip2-devel \
    file \
    gcc \
    gcc-c++ \
    glib2-devel \
    glibc-devel \
    ImageMagick \
    ImageMagick-devel \
    libcurl-devel \
    libevent-devel \
    libffi-devel \
    libjpeg-devel \
    libtool \
    libwebp-devel \
    libxml2-devel \
    libxslt-devel \
    libyaml-devel \
    make \
    mysql-devel \
    ncurses-devel \
    openssl-devel \
    patch \
    postgresql-devel \
    readline-devel \
    sqlite-devel \
    xz \
    xz-devel \
    zlib-devel \
    rpmdevtools


# Python and tools
RUN yum -y install python-devel; \
    wget -qO - https://bootstrap.pypa.io/get-pip.py | python

# St2 package build debs
RUN yum -y install \
    openldap-devel
