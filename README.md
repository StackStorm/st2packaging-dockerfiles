# StackStorm Docker Containers
[![Go to Docker Hub](https://img.shields.io/badge/Docker%20Hub-%E2%86%92-blue.svg)](https://hub.docker.com/r/stackstorm/)

This repository contains Dockerfiles for StackStorm. For a specific Dockerfile you can browse directly to a container sub directory.

## About StackStorm

[StackStorm](https://stackstorm.com/) is a powerful automation tool that wires together all of your apps, services and workflows. It’s extendable, flexible, and built with love for DevOps and ChatOps. It consists of bunch of components which bring Event-driven automation to you!

Here you can find Dockerfiles for *st2api, st2actionrunner, st2notifier etc* and all the components which StackStorm consists of.

## stackstorm container

Stackstorm container ([Dockerfile](Stackstorm/Dockerfile))  **is the base** for all of the **st2 components**. The full StackStorm stack is available inside the container. Notably that component containers such as *st2api, st2actionrunner etc* are basically the same container with the *stackstorm* container. The only hidden difference is the *ENV* settings. This approach minimizes the download snapshot when you want to run many stackstorm containers on the same node.

## Configuration

StackStorm components use Mongo database and RabbitMQ message queue service. When bringing up containers each component must know where db and queue are. All components except st2api also should know where st2api is.
There many ways to set this configuration, namely:

 - Using environment variables.
 - Using docker links.
 - Passing `/etc/st2/st2.conf` as volume.
 
These ways are sufficient for any use case, starting from a small docker compose development environment finishing with big discovery managed installations. Let's cover these.

### Using environment variables

St2 components the following environment variables:

 - **AMQP_URL** - url of rabbitmq, **default** is: `amqp://guest:guest@rabbitmq:5672/`.
 - **DB_HOST** - mongo database hostname or ip address, **default** is: `mongo`.
 - **DB_PORT** - mongo database listen port, **default** is: `27017`.
 - **API_URL** - stackstorm api endpoint. 

If you need any custom configuration, simple pass these environment variables to st2 docker containers and you are ready to go.

### Docker links

St2 components can automatically locate its dependencies. Just let alone the environment variables then and use container linking. St2 services expect containers with linked names: **mongo, rabbitmq** and **api**. This is the simplest way to get running. If you want to evaluate stackstorm containers just go this way. Since there are many st2 components, I will just show how to start api:

```shell
docker run -d --name mongo mongo
docker run -d --name rabbitmq rabbitmq
docker run -d --name api --link mongo:mongo --link rabbitmq:rabbitmq quay.io/stackstorm/api
```

Starting many services directly with docker CLI may become clumsy, so I'm not providing all these commands. For the information how all of the components are interconnected you might have look at [docker-compose.yml](docker-compose.yml). You can easily start the whole bundle as easy as this:

```
docker-compose up -d
docker-compose scale actionrunner=4
```

### Passing */etc/st2/st2.conf* as volume

In production use case you can direct configuration passing.


### Build and Deploy StackStorm Components to Docker Hub
Here is an example to build all StackStorm components and deploy them to Docker Hub.
It shows current automated CI & Deployment logic.

##### 1. Build `st2`
This is base image, which will be used as parent for StackStorm components.

```
# copy st2 deb package to directory where base Dockerfile is located
cp /tmp/st2-packages/st2*.deb stackstorm/

# note that version argument is required (make sure you have Docker 1.9+ installed for [this feature](https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg))
docker build --build-arg ST2_VERSION="1.1.2-5" -t st2 stackstorm/
```
where `1.1.2` is version and `5` is revision numbers (more metadata like this will be added later to Docker images).

##### 2. Build StackStorm components from the Base image
Once we have `st2` base Docker image, we can build child containers from it. Do for all StackStorm components:
```
docker build -t stackstorm/st2actionrunner:1.1.2 st2actionrunner/
docker build -t stackstorm/st2api:1.1.2 st2api/
docker build -t stackstorm/st2auth:1.1.2 st2auth/
docker build -t stackstorm/st2notifier:1.1.2 st2notifier/
docker build -t stackstorm/st2resultstracker:1.1.2 st2resultstracker/
docker build -t stackstorm/st2rulesengine:1.1.2 st2rulesengine/
docker build -t stackstorm/st2sensorcontainer:1.1.2 st2sensorcontainer/
docker build -t stackstorm/st2garbagecollector:1.1.2 st2garbagecollector/
```
> Make sure you tag Docker containers `X.Y.Z` for versioned `vX.Y.Z` branch in `st2`.
> `latest` Docker tag for `master` branch.

##### 3. Check if things installed
Very basic check:
```
docker run --name st2api -d stackstorm/st2api:1.1.2
docker exec st2docker st2 --version
```

##### 4. Deploy to Docker Hub
```
docker login -e ${DOCKER_EMAIL} -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}

docker push stackstorm/st2actionrunner:1.1.2
docker push stackstorm/st2api:1.1.2
docker push stackstorm/st2auth:1.1.2
docker push stackstorm/st2notifier:1.1.2
docker push stackstorm/st2resultstracker:1.1.2
docker push stackstorm/st2rulesengine:1.1.2
docker push stackstorm/st2sensorcontainer:1.1.2
docker push stackstorm/st2garbagecollector:1.1.2
```
