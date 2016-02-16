FROM buildpack-deps:jessie
RUN apt-get update -y

# Install python development
RUN apt-get -y install build-essential python2.7-dev python2.7 && \
    wget -qO - https://bootstrap.pypa.io/get-pip.py | python && \
    pip install setuptools virtualenv && \
    rm -rf /root/.cache

# Install debian build tools
RUN apt-get -y install devscripts debhelper dh-make

# St2 package build debs
RUN apt-get -y install libldap2-dev libsasl2-dev && \
    apt-get clean
