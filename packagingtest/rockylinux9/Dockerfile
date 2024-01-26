FROM rockylinux:9

# Download tools
RUN yum -y install \
    ca-certificates \
    wget

RUN yum -y install \
    git \
    iproute \
    openssh \
    procps \
    subversion \
    setup

RUN yum install -y yum-utils \
    && dnf install -y dnf-plugin-config-manager \
    && dnf config-manager --enable crb \
    && yum install -y epel-release \
    && yum -y install \
    mercurial \
    ImageMagick \
    ImageMagick-devel \
    libyaml-devel \
    libffi-devel \
    glibc-langpack-en \
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
    sqlite-devel \
    xz \
    xz-devel \
    zlib-devel \
    python39 \
    python3-devel \
    openssl-devel \
    pam \
    openssh-server \
    openssh-clients \
    setup \
    zip \
    unzip



# St2 package build debs
RUN yum -y install \
    openldap-devel

# Enable remote pubkey access
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdCmmPjsOBWRXc+PKdgDRrsciNjp25zTacyz8Gdkln2ma046brOYXAphhp/85DKgHtANBBt3cl4+HnpDbmAfyq2qZT7hWzAbMxtq0Sj+yyFyUdreXoe4gEKyxpV6o8p/R/XzEcawvqX/vFc5EIFmvTdamxZs9DQmOE5AZMzUB18Kerkrb0/arUcZ8iMi9Ng9a18avow+7oUFZ6Oub7ISz/dkIRojaKO/2paJZ4p+v7ZLn7Hq8TUeBkgAlx872oh8J8linhIq17zK6x4MGL8qiurp2hnfe0cuCxwcsYGy+4DfK51+E2vks6FprCIfF5hIdz26euPn67/YpM0F0b5nXF busybee@drone" >> /root/.ssh/authorized_keys

# Create busybee credentials and make busybee pkey available for root
COPY busybee*  /root/.ssh/
RUN chmod 600 /root/.ssh/busybee

RUN yum -y install openssh-server sudo && \
  ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key

# 1. small fix for SSH in ubuntu 13.10 (that's harmless everywhere else)
# 2. permit root logins and set simple password password and pubkey
# 3. change requiretty to !requiretty in /etc/sudoers
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
        sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
        sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
        sed -ri 's/requiretty/!requiretty/' /etc/sudoers && \
        echo 'root:docker.io' | chpasswd

RUN yum -y install nc net-tools glibc-locale-source && \
    # -i: specify the locale definition file
    # -f: specify the character set
    localedef -i en_US -f UTF-8 en_US.UTF-8

#EL9 enable RSA
RUN update-crypto-policies --set DEFAULT:SHA1

ENV LANG=en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV container docker

RUN yum -y update; \
    yum -y install systemd; yum clean all

RUN cd /lib/systemd/system/sysinit.target.wants/; ls -1 | grep -v systemd-tmpfiles-setup.service | xargs rm; \
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;\
    systemctl preset sshd;

# install doc files (/usr/share/docs) when installing yum packages
# otherwise /usr/share/docs/st2/conf/nginx/st2.conf won't be present
# https://github.com/docker-library/docs/tree/master/centos#package-documentation
RUN sed -i '/nodocs/d' /etc/yum.conf

# we can have ssh
EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
