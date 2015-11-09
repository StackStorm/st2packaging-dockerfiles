FROM debian:wheezy
LABEL com.stackstorm.version="1.2dev"

RUN apt-get -y update && apt-get -y install adduser procps python2.7 libffi5 libyaml-0-2

ADD ./st2bundle_1.2dev_amd64.deb /tmp/
RUN dpkg -i /tmp/st2bundle*.deb && rm -r /tmp/* && apt-get clean

ADD ./conf/st2.conf.template /st2.conf.template
RUN md5sum /etc/st2/st2.conf > /st2.conf.orig.md5

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME [ "/etc/st2", "/opt/stackstorm/packs" ]
ENTRYPOINT [ "/entrypoint.sh" ]
