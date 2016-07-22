# ST2 Docker system (WIP)

**WARNING: because of the needs for rapid testing and the goal of running StackStorm in a distributed fashion (think Mesos) this repo contains a lot of things and machinery that are tangential to running Stackstorm on Docker. They have been implemented to address the issues of automating syncing state at launch and update when container are distributed. From my experience with this I've come to the conclusion to make all the containers as utterly state
less as possible! However, I haven't had time to do this yet and rants about dynamically configured, hot reloading data companion containers (different from Companion Cubes) will have to wait for another day.**

For a variety of reasons that I will write down in detail at a later time, this repo is structured in the following way:

* All of the `mistral` and `st2` directories along with `stackstorm` contain `Dockerfile.template`s (and `docker_compose` container a `docker-compose.yml.template`).
* The `scripts` directory contains script files to build the templates and then do the docker builds.
  * If you take time to look through this you'll see that I'm hot building the templates on each build run and using bash variable indirection to cache all network dependencies for the build in each Dockerfile directory and then
rewriting the variable name as such (see the `check_cache` function in `scripts/build.sh`). Also, the use of `ARGS` in Dockerfiles is explicitly avoided to allow for all build layers to be cached.
* To make a build choose the target OS and what you'd like to build. Be sure to run this from the head of the repo!
  * Ex: `$ ./scripts/build.sh scripts/ubuntu_trusty_build.sh scripts/st2_1.5.1-4_conf.sh`
  * This works (in short) by loading the variables from `scripts/ubuntu_trusty_build.sh` (which will also pull cached files) and then loading the variables from `scripts/st2_1.5.1-4_conf.sh`. All variables are exported and thus the builds tag and other things for images reflect this.
  * All of these variables are then used to render the `*.template` files (`envsubst` is awesome).
  * Afterwards `scripts/build.sh` runs the build in two stages. If the second stage is used the first stage must only be one container and it will be used as the target for the second stage (see `scripts/st2_1.5.1-4_conf.sh` for examples of `STAGE1` and `STAGE2` use).
  * To just render the templates use `scripts/template.sh` instead of the build script.


All of this however doesn't explain the strange directories that are `data` and `entrypoint-wrapper`.

* `entrypoint-wrapper` contains a bash script (`entrypoint-wrapper.sh`) which will run and dynamically configure the container at launch before kicking off whatever is in `entrypoint.sh`. Currently this is used to pull a tar.gz file which is unpacked.
	* if a `copy_file.sh` is present in the tar it is run.
	* Then all `entrypoint.sh` files call `run_confd` which then uses confd to dynamically build the configuration files from environmental variables.

To fully see this do the following from the head of the repo:

* `./scripts/build.sh scripts/ubuntu_trusty_build.sh scripts/st2_1.5.1-4_conf.sh`
* `./make_tar.sh`
* Edit this line (`export HOST_IP="192.168.50.10"`) in `scripts/docker_compose_conf.sh` to reflect your IP address.
* `./scripts/template.sh scripts/ubuntu_trusty_build.sh scripts/docker_compose_conf.sh`
* In a separate terminal `cd` into `data` and run `python3 -m http.server`.
* This run `sudo docker-compose -f docker_compose/docker-compose.yml create`
* Launch rabbitmq and mongo (because some ST2 components crash if rabbitmq isn't immediately available) `sudo docker-compose -f docker_compose/docker-compose.yml start rabbitmq mongo`
* Launch stackstorm! `sudo docker-compose -f docker_compose/docker-compose.yml up`
* Go to port 8443 on your host machine!
* See that it fails to load the packs... which is my current issue :(


Other notes:

* all builds use dumb-init for correct signaling to containers and PID reaping.
* nginx logs to stdout
* Please comment if this doesn't work and you need help!
