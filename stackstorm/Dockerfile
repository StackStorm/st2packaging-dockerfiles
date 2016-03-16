FROM debian:wheezy

ARG ST2_VERSION
LABEL com.stackstorm.version="${ST2_VERSION}"

RUN apt-get -y update && apt-get -y install adduser procps python2.7 libffi5 libyaml-0-2 git libpcre3 libpython2.7 libxml2 python-dev libssl-dev libffi-dev sudo netcat

ADD ./st2_*.deb /tmp/
RUN dpkg -i /tmp/st2_*.deb && rm -r /tmp/* && apt-get clean

ADD ./conf/st2.conf.template /st2.conf.template
RUN md5sum /etc/st2/st2.conf > /st2.conf.orig.md5

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME [ "/etc/st2", "/opt/stackstorm/packs" ]
ENTRYPOINT [ "/entrypoint.sh" ]
