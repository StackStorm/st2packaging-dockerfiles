#!/bin/sh

wget -q -O - https://get.docker.io/gpg | apt-key add -
echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
apt-get update -qq; apt-get purge lxc-docker
apt-get install linux-image-extra-$(uname -r)
apt-get install -q -y --force-yes parallel #for doing parallel builds with scripts  
apt-get install -q -y --force-yes docker-engine
usermod -a -G docker vagrant

curl -sL https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

curl -sL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > /usr/local/bin/jq
chmod +x /usr/local/bin/jq;
