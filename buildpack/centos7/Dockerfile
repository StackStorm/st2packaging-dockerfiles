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


# Install rpmdevtools and epel-release
RUN yum -y install rpmdevtools epel-release
# Install python3
RUN yum -y install python3 python3-devel python3-virtualenv  && \
    pip3 install virtualenv==16.6.0 pip==19.1.1 wheel setuptools
RUN pip3 install --upgrade requests[security] venvctrl && rm -rf /root/.cache

# St2 package build debs
RUN yum -y install \
    openldap-devel
