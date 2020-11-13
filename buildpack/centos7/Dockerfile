FROM centos:7

# Download tools
RUN yum -y install \
    ca-certificates \
    curl \
    wget

# Build tools
RUN yum -y install \
    autoconf \
    automake \
    bzip2 \
    bzip2-devel \
    file \
    gcc \
    gcc-c++ \
    glib2-devel \
    glibc-devel \
    ImageMagick \
    ImageMagick-devel \
    libcurl-devel \
    libevent-devel \
    libffi-devel \
    libjpeg-devel \
    libtool \
    libwebp-devel \
    libxml2-devel \
    libxslt-devel \
    libyaml-devel \
    make \
    mysql-devel \
    ncurses-devel \
    openssl-devel \
    patch \
    postgresql-devel \
    readline-devel \
    sqlite-devel \
    xz \
    xz-devel \
    zlib-devel \
    rpmdevtools


# Install rpmdevtools and epel-release
RUN yum -y install rpmdevtools epel-release
RUN yum -y install python-devel && \
    wget -qO - https://bootstrap.pypa.io/get-pip.py | python && \
    pip install --upgrade "pip>=19.0.0,<20.0.0" && \
    pip install setuptools virtualenv && \
    rm -rf /root/.cache

# Install python3
#RUN pip3 install virtualenv==16.6.0 pip==19.1.1 wheel setuptools
# Following 4 get past wheel errors but get pip errors
#RUN yum -y install python3 python3-devel python3-virtualenv python3-wheel
#RUN pip3 install --upgrade pip==19.1.1  && \
#    pip3 install virtualenv==16.6.0 pip==19.1.1 wheel setuptools
#RUN pip3 install --upgrade requests[security] venvctrl && rm -rf /root/.cache
#
# With above combination we fail early on the pip import veresion from the python setup.py bdist_wheel command
#RUN yum -y install python3 python3-devel python3-virtualenv python3-wheel
#RUN wget -qO get-pip.py https://bootstrap.pypa.io/get-pip.py
#RUN python3 get-pip.py --force-reinstall && \
#    pip3 install --upgrade pip==19.1.1 && \
#    pip3 install virtualenv==16.6.0 pip==19.1.1 wheel setuptools && \
#    rm -rf /root/.cache
# If we take out virtualenv and wheel from python3 still have same problem...
#RUN yum -y install python3 python3-devel
#RUN wget -qO get-pip.py https://bootstrap.pypa.io/get-pip.py
#RUN python3 get-pip.py --force-reinstall && \
#    pip3 install --upgrade pip==19.1.1 && \
#    pip3 install virtualenv==16.6.0 pip==19.1.1 wheel setuptools && \
#    rm -rf /root/.cache
#    Following fail on early import of pip on __version__ by python3 setup.py bdist_wheel
#RUN yum -y install python3 python3-devel python3-virtualenv  python3-wheel
#RUN python3 -m pip uninstall pip -y
#RUN wget -qO - https://bootstrap.pypa.io/get-pip.py | python3 && \
#    pip3 install --upgrade "pip>=19.0.0,<20.0.0" && \
#    pip3 install --upgrade virtualenv==16.6.0 wheel && \
#    pip3 install setuptools
#RUN pip3 install --upgrade requests[security] venvctrl && rm -rf /root/.cache
## This combinations fails reallyl on with no comand bdist_wheel
#RUN yum -y install python3 python3-devel python3-virtualenv  python3-wheel
#RUN pip3 install --upgrade "pip==19.1.1" && \
#    pip3 install --upgrade virtualenv==16.6.0 wheel && \
#    pip3 install setuptools
#RUN pip3 install --upgrade requests[security] venvctrl && rm -rf /root/.cache
#
# Below combinations fails as gets past problems with initial wheel but then fails on pip internal
# pip3 wheel --wheel-dir=/code/st2-rbac-backend/build/BUILDROOT/st2-rbac-backend-3.3dev-10.x86_64/opt/stackstorm/share/wheels -r requirements.txt -r test-requirements.txt
# Traceback (most recent call last):
#   File "/usr/local/bin/pip3", line 7, in <module>
#       from pip._internal import main
#       ModuleNotFoundError: No module named 'pip._internal'
#       make[1]: Leaving directory `/code/st2-rbac-backend'
RUN yum -y install python3 python3-devel python3-virtualenv  python3-wheel
RUN pip3 install --upgrade "pip==19.1.1" && \
    pip3 install --upgrade virtualenv==16.6.0 && \
    pip3 install setuptools wheel
RUN pip3 install --upgrade requests[security] venvctrl && rm -rf /root/.cache


# Install python3
# Install python3

# St2 package build debs
RUN yum -y install \
   openldap-devel
