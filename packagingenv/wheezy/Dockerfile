FROM quay.io/dennybaa/droneunit:wheezy
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

# We use must fresh version >= 0.8 of dh-virtualenv, but jessie offers 0.7.
# So we build it from source.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
        python-setuptools python-sphinx python-mock python-virtualenv && \
        apt-get clean && \
        git clone https://github.com/dennybaa/dh-virtualenv.git /tmp/dh-virtualenv && \
        cd /tmp/dh-virtualenv && \
        dpkg-buildpackage -b -uc -us && dpkg -i ../dh-virtualenv_*.deb && \
        rm -rf /tmp/dh-virtualenv*

# Install fresh pip and co
RUN curl https://bootstrap.pypa.io/get-pip.py | python; pip install --upgrade wheel virtualenv \
      requests[security] && rm -rf /root/.cache

VOLUME ['/home/busybee/build']
EXPOSE 22

# Run ssh daemon in foreground and wait for bees to connect.
CMD ["/usr/sbin/sshd", "-D"]
