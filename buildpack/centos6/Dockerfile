FROM centos:6

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
RUN wget https://bintray.com/stackstorm/el6/rpm -O /etc/yum.repos.d/stackstorm-el6.repo && \
      sed -ir 's~stackstorm/el6~stackstorm/el6/stable~' /etc/yum.repos.d/stackstorm-el6.repo && \
      yum -y install st2python && rm -rf /tmp/*

ENV PATH=/usr/share/python/st2python/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN wget -qO - https://bootstrap.pypa.io/get-pip.py | python && \
    pip install --upgrade "pip>=19.0.0,<20.0.0" && \
    pip install setuptools virtualenv && \
    rm -rf /root/.cache


# St2 package build debs
RUN yum -y install \
    openldap-devel
