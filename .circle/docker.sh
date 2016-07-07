#!/bin/bash
set -e

### Pass these ENV Variables for this script to consume:
# DEPLOY_DOCKER - Should this script push created images to Docker Hub? (0/1)

# DOCKER_USER - Docker Hub Username to login
# DOCKER_EMAIL - Docker Hub Email to login
# DOCKER_PASSWORD - Docker Hub Password to Login

# ST2_GITREV - st2 branch name (ex: master, v1.2.1). This will be used to determine correct Docker Tag: `latest`, `1.2.1`
# ST2PKG_VERSION - st2 version, will be reused in Docker image metadata (ex: 1.2dev)
# ST2PKG_RELEASE - Release number aka revision number for `st2` package, will be reused in Docker metadata (ex: 4)

### Usage:
# docker.sh build st2 - Build base Docker image with `st2` installed. This will be reused by child containers
# docker.sh build st2actionrunner st2api st2auth st2exporter st2notifier st2resultstracker st2rulesengine st2sensorcontainer - Build child Docker images based on `st2`, - previously created Docker image
# docker.sh run st2api - Start detached `st2api` docker image
# docker.sh test st2api 'st2 --version' - Exec command inside already started `st2api` Docker container
# docker.sh deploy st2api st2auth st2exporter st2notifier st2resultstracker st2rulesengine st2sensorcontainer - Push images to Docker Hub

: ${DEPLOY_DOCKER:=1}

# Required ENV variables
: ${ST2PKG_VERSION:? ST2PKG_VERSION env is required}
: ${ST2PKG_RELEASE:? ST2PKG_RELEASE env is required}
: ${ST2PKG_STAGING:=1}

case "$1" in
  build)
    case "$2" in
      st2)
        : ${pkgsgaging:=$([ $ST2PKG_STAGING -gt 0 ] && echo 'staging-')}
        : ${pkgrepo:=$(echo ${ST2PKG_VERSION} | grep -q 'dev' && echo 'unstable' || echo 'stable')}
        docker build --build-arg ST2_VERSION="${ST2PKG_VERSION}-${ST2PKG_RELEASE}" --build-arg ST2_REPO="${pkgsgaging}${pkgrepo}" -t st2 stackstorm/
      ;;
      *)
        for container in "${@:2}"; do
          docker build -t stackstorm/${container}:latest ${container}
        done
      ;;
    esac
  ;;
  run)
    docker run --name "$2" -d stackstorm/"$2":latest
  ;;
  test)
    # Verify Container by running `st2` command in it
    # Same as: docker exec st2docker st2 --version
    # See: https://circleci.com/docs/docker#docker-exec
    sudo lxc-attach -n "$(docker inspect --format '{{.Id}}' ${2})" -- bash -c "${3}"
  ;;
  deploy)
    if [ ${DEPLOY_DOCKER} -eq 0 ]; then
      echo 'Skipping Docker push because DEPLOY_DOCKER=0'
      exit
    fi

    for container in "${@:2}"; do
      docker tag stackstorm/${container}:latest stackstorm/${container}:${ST2PKG_VERSION}
    done

    docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}

    echo 'Pushing StackStorm images to Docker Hub in parallel ...'
    parallel -v -j0 --line-buffer docker push stackstorm/{}:${ST2PKG_VERSION} ::: ${@:2}
  ;;
esac
