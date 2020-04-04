FROM centos:8

# Download tools
RUN yum -y install \
    ca-certificates \
    curl \
    wget

RUN yum install -y yum-utils \
    && dnf config-manager --enable PowerTools \
    && yum install -y epel-release \
    && yum -y install \
    ImageMagick \
    ImageMagick-devel \
    libyaml-devel \
    && dnf config-manager --disable PowerTools \
    && yum remove -y epel-release yum-utils

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
    libcurl-devel \
    libevent-devel \
    libffi-devel \
    libjpeg-devel \
    libtool \
    libwebp-devel \
    libxml2-devel \
    libxslt-devel \
    make \
    mysql-devel \
    ncurses-devel \
    openssl-devel \
    patch \
    postgresql-devel \
    readline-devel \
    rpmdevtools \
    sqlite-devel \
    which \
    xz \
    xz-devel \
    zlib-devel


# Python and tools
RUN yum -y install python3 python3-devel python3-wheel && \
    pip3 install virtualenv && \
    rm -rf /root/.cache

# St2 package build debs
RUN yum -y install \
    openldap-devel
