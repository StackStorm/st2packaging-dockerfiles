#!/bin/bash
set -e

### Pass these ENV Variables for this script to consume:
# DEPLOY_DOCKER - Should this script push created images to Docker Hub? (0/1)
# DEPLOY_LATEST - Should this script push created images to Docker Hub marked with latest tag? (0/1)

# DOCKER_USER - Docker Hub Username to login
# DOCKER_EMAIL - Docker Hub Email to login
# DOCKER_PASSWORD - Docker Hub Password to Login

# ST2PKG_VERSION - st2 version, will be reused in Docker image metadata (ex: 1.2dev)
# ST2PKG_RELEASE - Release number aka revision number for `st2` package, will be reused in Docker metadata (ex: 4)

# PACKAGECLOUD_ORGANIZATION (default: stackstorm)
# PACKAGECLOUD_TOKEN

### Usage:
# docker.sh build st2 - Build base Docker image with `st2` installed. This will be reused by child containers
# docker.sh build st2actionrunner st2api st2auth st2exporter st2notifier st2resultstracker st2rulesengine st2sensorcontainer - Build child Docker images based on `st2`, - previously created Docker image
# docker.sh run st2api - Start detached `st2api` docker image
# docker.sh test st2api 'st2 --version' - Exec command inside already started `st2api` Docker container
# docker.sh deploy st2api st2auth st2exporter st2notifier st2resultstracker st2rulesengine st2sensorcontainer - Push images to Docker Hub

: ${DEPLOY_DOCKER:=0}
: ${DEPLOY_LATEST:=0}

: ${ST2PKG_VERSION:? ST2PKG_VERSION env is required}
: ${ST2PKG_STAGING:=1}

case "$1" in
  build)
    case "$2" in
      st2)
        : ${PACKAGECLOUD_ORGANIZATION:=stackstorm}
        : ${PACKAGECLOUD_TOKEN:? PACKAGECLOUD_TOKEN env is required}

        : ${pkgtype:=deb}
        : ${pkgdistro:=debian}
        : ${pkgflavor:=wheezy}
        : ${pkgstaging:=$([ $ST2PKG_STAGING -gt 0 ] && echo 'staging-')}
        : ${pkgrepo:=$(echo ${ST2PKG_VERSION} | grep -q 'dev' && echo 'unstable' || echo 'stable')}

        : ${ST2PKG_RELEASE:=$( \
          curl -sS -q https://$PACKAGECLOUD_TOKEN:@packagecloud.io/api/v1/repos/$PACKAGECLOUD_ORGANIZATION/${pkgstaging}${pkgrepo}/package/$pkgtype/$pkgdistro/$pkgflavor/st2/amd64/versions.json \
          | jq -r "[.[] | select(.version == \"$ST2PKG_VERSION\")] | last | .release" \
        )}

        docker build --build-arg ST2_VERSION="${ST2PKG_VERSION}-${ST2PKG_RELEASE}" --build-arg ST2_REPO="${pkgstaging}${pkgrepo}" -t st2 stackstorm/
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

    docker login -e ${DOCKER_EMAIL} -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}

    echo "Pushing StackStorm ${ST2PKG_VERSION} images to Docker Hub in parallel ..."
    parallel -v -j0 --line-buffer docker push stackstorm/{}:${ST2PKG_VERSION} ::: ${@:2}

    if [ ${DEPLOY_LATEST} -eq 0 ]; then
      echo 'Skipping Docker push for latest tag because DEPLOY_LATEST=0'
      exit
    fi

    echo "Pushing latest StackStorm images to Docker Hub in parallel ..."
    parallel -v -j0 --line-buffer docker push stackstorm/{}:latest ::: ${@:2}
  ;;
esac
