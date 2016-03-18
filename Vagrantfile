VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.network "public_network"

  config.vm.box = "phusion/ubuntu-14.04-amd64"

  # Install Docker
  pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
    "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
    "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
  # Add vagrant user to the docker group
  pkg_cmd << "usermod -a -G docker vagrant; "
  pkg_cmd << "curl -sL https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose;" \
    "chmod +x /usr/local/bin/docker-compose; "
  config.vm.provision :shell, :inline => pkg_cmd
end
