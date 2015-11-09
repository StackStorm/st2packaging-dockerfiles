# ![](https://stackstorm.com/wp/wp-content/uploads/2014/10/stackstorm-logo-header.png)  StackStorm Docker containers
This repository contains Dockerfiles for StackStorm. For a specific Dockerfile you can browse directly to a container sub directory. Built docker images are currently available at https://quay.io/stackstorm.

## About StackStorm

[StackStorm](https://stackstorm.com/) is a powerful automation tool that wires together all of your apps, services and workflows. It’s extendable, flexible, and built with love for DevOps and ChatOps. It consists of bunch of services which bring Event-driven automation to you!

Here you can find Dockerfiles for *st2api, st2actionrunner, st2notifier etc* and all the services which StackStorm consists of.

## stackstorm container

Stackstorm container ([Dockerfile](Stackstorm/Dockerfile))  **is the base** for all of the **st2 services**. The full StackStorm stack is available inside the container. Notably that service containers such as *st2api, st2actionrunner etc* are basically the same container with the *stackstorm* container. The only hidden difference is the *ENV* settings. This approach minimizes the download snapshot when you want to run many stackstorm containers on the same node.

## ...

