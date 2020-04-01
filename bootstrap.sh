#!/bin/sh

apt-get update --quiet --quiet
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update --quiet --quiet
apt-get install --quiet --yes docker-ce docker-ce-cli docker-compose jq
usermod -a -G docker vagrant
