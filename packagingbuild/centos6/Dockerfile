FROM centos:6

# Download tools
RUN yum -y install \
    ca-certificates \
    curl \
    wget

RUN yum -y install \
    bzr \
    git \
    mercurial \
    openssh \
    subversion

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
    zlib-devel

# St2 package build debs
RUN yum -y install \
    openldap-devel

# Enable remote pubkey access
RUN mkdir /root/.ssh && chmod 700 /root/.ssh && \
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

RUN yum -y install nc net-tools

#
# Buildenv is special environment for generating debian packages. It provides:
#   - All needed pre-installed development packages
#   - SSH access for build executor.
#

RUN yum -y install tar xz rpmdevtools

# Install st2python from our repository
RUN wget https://bintray.com/stackstorm/el6/rpm -O /etc/yum.repos.d/stackstorm-el6.repo && \
      sed -ir 's~stackstorm/el6~stackstorm/el6/stable~' /etc/yum.repos.d/stackstorm-el6.repo && \
      yum -y install st2python && rm -rf /tmp/*

# Install fresh pip and co
RUN PATH=/usr/share/python/st2python/bin:$PATH bash -c \
      "curl https://bootstrap.pypa.io/get-pip.py | python - pip==7.1.2 wheel==0.26.0 setuptools==18.7.1; \
        pip install --upgrade virtualenv \
        requests[security] venvctrl" \
    && rm -rf /root/.cache

VOLUME ['/home/busybee/build']
EXPOSE 22

# Run ssh daemon in foreground and wait for bees to connect.
CMD ["/usr/sbin/sshd", "-D"]
