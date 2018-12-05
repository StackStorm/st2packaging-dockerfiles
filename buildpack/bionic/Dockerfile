FROM buildpack-deps:bionic
RUN apt-get update -y

# Install python development
RUN apt-get -y install build-essential python2.7-dev python2.7 python3-dev python3 python3-virtualenv python3-pip && \
    wget -qO - https://bootstrap.pypa.io/get-pip.py | python && \
    pip3 install --upgrade "pip>=9.0.0,<10.0.0" && \
    pip3 install setuptools virtualenv && \
    rm -rf /root/.cache

# Install debian build tools
RUN apt-get -y install devscripts debhelper dh-make

# St2 package build debs
RUN apt-get -y install libldap2-dev libsasl2-dev && \
    apt-get clean
