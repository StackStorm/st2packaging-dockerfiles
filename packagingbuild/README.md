# Packagingbuild Dockerfiles
[![Go to packagingbuild Docker Hub](https://img.shields.io/badge/Docker%20Hub-packagingbuild-blue.svg)](https://hub.docker.com/r/stackstorm/packagingbuild/)

Docker images used to build `.deb` and `.rpm` StackStorm packages in [StackStorm/st2-packages](https://github.com/StackStorm/st2-packages/blob/master/docker-compose.circle.yml) CI/CD.

In these containers build environment specific for each OS distro is pre-installed and respective StackStorm packages are built for each platform.

[`Dockerfiles` sources](https://github.com/StackStorm/st2packaging-dockerfiles/blob/master/packagingbuild):
- CentOS 7
- CentOS 8
- Ubuntu Bionic
- Ubuntu Focal

NB!
Images are built automatically in Docker Hub on every push to [StackStorm/st2packaging-dockerfiles](https://github.com/StackStorm/st2packaging-dockerfiles/) `master`.
