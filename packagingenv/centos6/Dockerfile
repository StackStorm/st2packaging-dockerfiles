FROM quay.io/dennybaa/droneunit:centos6
#
# Buildenv is special environment for generating debian packages. It provides:
#   - All needed pre-installed development packages
#   - SSH access for build executor.
#

RUN yum -y install tar xz rpmdevtools

# Old old uhf :( we need a fresh python in /usr/local/bin
RUN curl -L http://www.python.org/ftp/python/2.7.10/Python-2.7.10.tar.xz -o /tmp/py27.tar.xz && \
        cd /tmp/ && tar -xJf /tmp/py27.tar.xz && cd Python-2.7.10 && \
        ./configure && make && make install && cd && rm -rf /tmp/*

# Install fresh pip and co
RUN curl https://bootstrap.pypa.io/get-pip.py | python; pip install --upgrade virtualenv \
      requests[security] venvctrl && rm -rf /root/.cache

VOLUME ['/home/busybee/build']
EXPOSE 22

# Run ssh daemon in foreground and wait for bees to connect.
CMD ["/usr/sbin/sshd", "-D"]
