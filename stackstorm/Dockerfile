FROM debian:wheezy

ARG ST2_VERSION
ARG ST2_REPO=staging-stable
ARG ST2_PACKAGE=https://packagecloud.io/StackStorm/${ST2_REPO}/packages/debian/wheezy/st2_${ST2_VERSION}_amd64.deb/download

LABEL com.stackstorm.version="${ST2_VERSION}"

ADD ./sources.list /etc/apt/

RUN apt-get -y update && apt-get -y install wget adduser procps python2.7 libffi5 libyaml-0-2 git libpcre3 libpython2.7 libxml2 python-dev libssl-dev libffi-dev sudo

RUN wget ${ST2_PACKAGE} -O /tmp/st2_${ST2_VERSION}_amd64.deb
RUN dpkg -i /tmp/st2_${ST2_VERSION}_amd64.deb && rm -r /tmp/st2_${ST2_VERSION}_amd64.deb && apt-get clean

ADD ./conf/st2.conf.template /st2.conf.template
RUN md5sum /etc/st2/st2.conf > /st2.conf.orig.md5

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME [ "/etc/st2", "/opt/stackstorm/packs" ]
ENTRYPOINT [ "/entrypoint.sh" ]
