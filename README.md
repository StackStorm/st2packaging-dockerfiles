# Docker images used to build [StackStorm packages](https://github.com/stackstorm/st2-packages)
[![Go to Docker Hub](https://img.shields.io/badge/Docker%20Hub-%E2%86%92-blue.svg)](https://hub.docker.com/r/stackstorm/)

> *Note:*
For official StackStorm Docker repo, go https://github.com/StackStorm/st2-dockerfiles<br>
Interested in StackStorm HA in Kubernetes? Check https://github.com/stackstorm/stackstorm-ha

This repository contains Dockerfiles, used by StackStorm team for CI and some other specific needs.

## `packagingbuild`
`Dockerfiles` with ready to use environment to build `.deb` and `.rpm` StackStorm packages in [StackStorm/st2-packages](https://github.com/StackStorm/st2-packages/blob/master/docker-compose.circle.yml) CI/CD.

See [packagingbuild/](packagingbuild/)

## `packagingtest`
`Dockerfiles` with pre-installed init system used to test `.deb` and `.rpm` StackStorm packages in [StackStorm/st2-packages](https://github.com/StackStorm/st2-packages/blob/master/docker-compose.circle.yml) CI/CD.

See [packagingtest/](packagingtest/)

# How To Build Theses Containers (developer)

If you're a developer looking to modify / test / build these containers simply, change into 
the container's directory and do the following:

``` shell
cd st2packaging-dockerfiles/packagingbuild/bionic
docker build -t stackstorm/packagingbuild:bionic .

cd st2packaging-dockerfiles/packagingtest/bionic/systemd
docker build -t stackstorm/packagingtest:bionic .
```
