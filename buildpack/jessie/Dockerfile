FROM buildpack-deps:jessie

# Install python development
RUN apt-get update && \
    apt-get -y install build-essential python-dev python ; \
    wget -qO - https://bootstrap.pypa.io/get-pip.py | python; \
    rm -rf /root/.cache

# Install debian build tools
RUN apt-get -y install devscripts debhelper dh-make

# St2 package build debs
RUN apt-get -y install libldap-dev ; \
    apt-get clean
