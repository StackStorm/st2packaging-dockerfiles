FROM quay.io/dennybaa/drone-busybee:centos7
#
# Buildenv is special environment for generating debian packages. It provides:
#   - All needed pre-installed development packages
#   - SSH access for build executor.
#

# Install development tools
RUN yum -y install python-devel rpmdevtools

# Install fresh pip and co
RUN curl https://bootstrap.pypa.io/get-pip.py | python; pip install --upgrade virtualenv \
      requests[security] venvctrl && rm -rf /root/.cache

VOLUME ['/home/busybee/build']
EXPOSE 22

# Run ssh daemon in foreground and wait for bees to connect.
CMD ["/usr/sbin/sshd", "-D"]
