# Packagingtest Dockerfiles
[![Go to packagingtest Docker Hub](https://img.shields.io/badge/Docker%20Hub-packagingtest-blue.svg)](https://hub.docker.com/r/stackstorm/packagingtest/)

Docker images with pre-installed init system used to test `.deb` and `.rpm` StackStorm packages in [StackStorm/st2-packages](https://github.com/StackStorm/st2-packages/blob/master/docker-compose.circle.yml) CI/CD.

In these containers built artifacts are tested: StackStorm packages are installed, configuration is written, dependent services like MongoDB, RabbitMQ, PostgreSQL are started and end-to-end tests are performed, like on real OS with specific init system.

[`Dockerfiles` sources](https://github.com/StackStorm/st2packaging-dockerfiles/blob/master/packagingtest):
- CentOS 7
- CentOS 8
- CentOS Stream 9
- Ubuntu Focal
- Ubuntu Jammy

NB!
Images are built automatically on every push to [StackStorm/st2packaging-dockerfiles](https://github.com/StackStorm/st2packaging-dockerfiles/) `master`.
