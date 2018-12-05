FROM buildpack-deps:bionic
RUN apt-get update -y

# Install python development
RUN apt-get -y install build-essential python2.7-dev python2.7 python3-dev python3 python3-virtualenv python3-pip && \
    rm -rf /root/.cache

# pin virtualenv to '15.1.0' (installs pip 9) due to dh-virtualenv incompatibility with pip 10.0
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 - virtualenv==15.1.0 pip==9.0.1 wheel==0.29.0 setuptools==28.0.0; \
      pip3 install --upgrade requests[security] && rm -rf /root/.cache

# Install debian build tools
RUN apt-get -y install devscripts debhelper dh-make

# St2 package build debs
RUN apt-get -y install libldap2-dev libsasl2-dev && \
    apt-get clean
