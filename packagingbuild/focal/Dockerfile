FROM buildpack-deps:focal

# Make noninteractive setting permanent
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections -v

# Enable remote pubkey access
RUN mkdir /root/.ssh && chmod 700 /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdCmmPjsOBWRXc+PKdgDRrsciNjp25zTacyz8Gdkln2ma046brOYXAphhp/85DKgHtANBBt3cl4+HnpDbmAfyq2qZT7hWzAbMxtq0Sj+yyFyUdreXoe4gEKyxpV6o8p/R/XzEcawvqX/vFc5EIFmvTdamxZs9DQmOE5AZMzUB18Kerkrb0/arUcZ8iMi9Ng9a18avow+7oUFZ6Oub7ISz/dkIRojaKO/2paJZ4p+v7ZLn7Hq8TUeBkgAlx872oh8J8linhIq17zK6x4MGL8qiurp2hnfe0cuCxwcsYGy+4DfK51+E2vks6FprCIfF5hIdz26euPn67/YpM0F0b5nXF busybee@drone" >> /root/.ssh/authorized_keys

# Create busybee credentials and make busybee pkey available for root
COPY busybee*  /root/.ssh/
RUN chmod 600 /root/.ssh/busybee

RUN apt-get -y update && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd

# 1. permit root logins and set simple password password and pubkey
# 2. change requiretty to !requiretty in /etc/sudoers
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -ri 's/requiretty/!requiretty/' /etc/sudoers && \
    echo 'root:docker.io' | chpasswd

# install core software for packaging and ssh communication
RUN echo -e "#!/bin/sh\nexit 101\n" > /usr/sbin/policy-rc.d && \
    apt-get -y update && \
    apt-get -y install gdebi-core sshpass cron netcat net-tools

#
# Buildenv is special environment for generating debian packages. It provides:
#   - All needed pre-installed development packages
#   - SSH access for build executor.
#

# install python development
RUN apt-get update && \
    apt-get -y install build-essential python3-dev python3

RUN apt-get update && \
    apt-get -y install \
        devscripts debhelper dh-make libldap2-dev libsasl2-dev && apt-get clean

# Install fresh pip and co
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.8 - virtualenv==20.4.0 pip==20.3.3 wheel==0.36.2 setuptools==51.3.3 cryptography; \
      pip3.8 install --upgrade requests[security] && rm -rf /root/.cache

# This line just busts Docker's cache so it re-runs the next line
# The GitHub API will return different results when the branch HEAD changes
# See https://stackoverflow.com/a/39278224
# ADD https://api.github.com/repos/StackStorm/dh-virtualenv/git/refs/heads/stackstorm_patched version.json
# RUN rm version.json

# Use upstream dh-virtualenv master branch that includes StackStorm's 'python' shebang fix since 8 Dec 2020.
# We reset the repository to use the known good commit sha id 2dc93574865d6dd9e1fc470541e3232dcbad3337
RUN apt-get -y install \
        python3.8-venv python3-setuptools python3-mock python3-sphinx dh-exec dh-python libjs-jquery libjs-underscore python3-sphinx-rtd-theme && \
        apt-get clean && \
        git clone --branch master https://github.com/spotify/dh-virtualenv.git /tmp/dh-virtualenv && \
        cd /tmp/dh-virtualenv && \
        git reset --hard 2dc93574865d6dd9e1fc470541e3232dcbad3337 && \
        dpkg-buildpackage -b -uc -us && dpkg -i ../dh-virtualenv_*.deb && \
        rm -rf /tmp/dh-virtualenv*
RUN apt-get -y install dh-systemd && apt-get clean


VOLUME ['/home/busybee/build']
EXPOSE 22

# Run ssh daemon in foreground and wait for bees to connect.
CMD ["/usr/sbin/sshd", "-D"]
