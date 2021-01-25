FROM buildpack-deps:bionic
RUN apt-get update -y

# Install python development
RUN apt-get -y install build-essential python2.7-dev python2.7 python3-dev python3 python3-virtualenv python3-pip && \
    rm -rf /root/.cache

# Install fresh pip and co
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 - \
        pip==20.3.4 \
        setuptools \
        virtualenv==16.6.0 \
        wheel; \
      pip3 install --upgrade requests[security] && rm -rf /root/.cache

# Install debian build tools
RUN apt-get -y install devscripts debhelper dh-make

# St2 package build debs
RUN apt-get -y install libldap2-dev libsasl2-dev && \
    apt-get clean
