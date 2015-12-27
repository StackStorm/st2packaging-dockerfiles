FROM quay.io/dennybaa/droneunit:centos6
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
      "curl https://bootstrap.pypa.io/get-pip.py | python; pip install --upgrade virtualenv \
        requests[security] venvctrl" \
    && rm -rf /root/.cache

VOLUME ['/home/busybee/build']
EXPOSE 22

# Run ssh daemon in foreground and wait for bees to connect.
CMD ["/usr/sbin/sshd", "-D"]
