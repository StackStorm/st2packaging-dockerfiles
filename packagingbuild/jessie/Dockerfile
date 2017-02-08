FROM buildpack-deps:jessie

# Enable remote pubkey access
RUN mkdir /root/.ssh && chmod 700 /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdCmmPjsOBWRXc+PKdgDRrsciNjp25zTacyz8Gdkln2ma046brOYXAphhp/85DKgHtANBBt3cl4+HnpDbmAfyq2qZT7hWzAbMxtq0Sj+yyFyUdreXoe4gEKyxpV6o8p/R/XzEcawvqX/vFc5EIFmvTdamxZs9DQmOE5AZMzUB18Kerkrb0/arUcZ8iMi9Ng9a18avow+7oUFZ6Oub7ISz/dkIRojaKO/2paJZ4p+v7ZLn7Hq8TUeBkgAlx872oh8J8linhIq17zK6x4MGL8qiurp2hnfe0cuCxwcsYGy+4DfK51+E2vks6FprCIfF5hIdz26euPn67/YpM0F0b5nXF busybee@drone" >> /root/.ssh/authorized_keys

# Create busybee credentials and make busybee pkey available for root
COPY busybee*  /root/.ssh/
RUN chmod 600 /root/.ssh/busybee

RUN DEBIAN_FRONTEND=noninteractive && apt-get -y update && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd

# 1. small fix for SSH in ubuntu 13.10 (that's harmless everywhere else)
# 2. permit root logins and set simple password password and pubkey
# 3. change requiretty to !requiretty in /etc/sudoers
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
        sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
        sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
        sed -ri 's/requiretty/!requiretty/' /etc/sudoers && \
        echo 'root:docker.io' | chpasswd

# install core software for packaging and ssh communication
RUN echo -e "#!/bin/sh\nexit 101\n" > /usr/sbin/policy-rc.d && \
    DEBIAN_FRONTEND=noninteractive && apt-get -y update && \
    apt-get -y install gdebi-core sshpass cron \
      netcat net-tools

#
# Buildenv is special environment for generating debian packages. It provides:
#   - All needed pre-installed development packages
#   - SSH access for build executor.
#


# install python development
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get -y install build-essential python-dev python


RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
        devscripts debhelper dh-make && apt-get clean

# We use our version, since it fixes shebangd lines rewrites
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
        python-setuptools python-sphinx python-mock python-virtualenv && \
        apt-get clean && \
        git clone https://github.com/dennybaa/dh-virtualenv.git /tmp/dh-virtualenv && \
        cd /tmp/dh-virtualenv && \
        dpkg-buildpackage -b -uc -us && dpkg -i ../dh-virtualenv_*.deb && \
          rm -rf /tmp/dh-virtualenv*

# Install fresh pip and co
RUN curl https://bootstrap.pypa.io/get-pip.py | python - pip==7.1.2 wheel==0.26.0 setuptools==18.7.1; \
      pip install --upgrade wheel virtualenv \
      requests[security] && rm -rf /root/.cache

VOLUME ['/home/busybee/build']
EXPOSE 22

# Run ssh daemon in foreground and wait for bees to connect.
CMD ["/usr/sbin/sshd", "-D"]
