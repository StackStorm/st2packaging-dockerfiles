# dockerfiles

Repository contains multiple image projects. Image project can contain template files which will be used to generate resulting dockerfiles. For template automation procedures there are two scripts available:

 - **update.py** - generates dockerfiles from given template files.
 - **publish.py** - builds and publishes containers to a docker registry hub, such as https://registry.hub.docker.com or https://quay.io.
 
## A short intro to templating

Let's start with dockerfiles layout first:
```
.
├── buildpack
│   ├── centos6
│   │   ├── curl
│   │   │   └── Dockerfile
│   │   ├── Dockerfile
│   │   └── scm
│   │       └── Dockerfile
│   ├── centos7
│   │   ├── curl
│   │   │   └── Dockerfile
│   │   ├── Dockerfile
│   │   └── scm
│   │       └── Dockerfile
│   ├── Dockerfile.template
│   ├── Dockerfile.template-curl
│   ├── Dockerfile.template-scm
│   ├── fedora21
│   │   ├── curl
│   │   │   └── Dockerfile
│   │   ├── Dockerfile
│   │   └── scm
│   │       └── Dockerfile
│   ├── fedora22
│   │   ├── curl
│   │   │   └── Dockerfile
│   │   ├── Dockerfile
│   │   └── scm
│   │       └── Dockerfile
│   └── suite.yml
├── dist.yml
```
Dockerfiles contains **multiple image projects** such as buildpack. Each project contains source templates supporting jinja2 templating.

Inside image project you need to create **suites**, **update.py** automatically populates each of the suites. Suite is basically a name reflecting distribution, version or maybe both.  Going a level deeper we meet **variants** which correspond to the same suite but a different image project.

When you run **update.py** generation of the described hierarchy takes place. For example the script creates `fedora21/Dockerfile`, `fedora21/scm/Dockerfile` which correspond to `buildpack:fedora21` and `buildpack:fedora21-scm` images. So as you can see generated images name represents the following pattern **{{image}}:{{suite}}[-{{variant}}]**.

## Configuration

### dist.yml

Let's look at **dist.yml**, it contains patterns which map distribution names to suites.

```yaml
fedora:
  - !regexp fedora([0-9.]+)
centos:
  - !regexp centos([0-9.]+)
ubuntu-debootstrap:
  - xenial
  - bionic
```

From the above example we can clearly see that ubuntu has two suites: xenial and bionic. Notable feature of this format is that it supports regex, so fedora distribution maps to suites described by *regular expression*. The first group match here makes particular sense it defines a version group. This is done because we say it generate **fedora21** suite but the upstream image doesn't have such a tag, versioning however helps you to inherit from *fedora:21*.

### suite.yml

Let's look at **suite.yml** of droneunit image project:

```yaml
registry: quay.io/dennybaa/
variants:
  - null
  - systemd:
    - xenial
latest: xenial
```

The **registry** prefix sets registry prefix which means that when image is build (ex. droneunit) it will get name for example such as `quay.io/dennybaa/droneunit:xenial`.

**Variants** define what variants are available for particular suites, so for the *upstart* variant there are only two suites, but for the **default** variant Dockerfiles are generated for all of the suites. In other words when you don't expand variant as a list and all suites will be generated for this variant.


## update.py and publish.py help

**But first do** `pip -r requirements.txt`.

**update.py**:
```
usage: update.py [-h] [image] [suite [suite ...]]

Generate Dockerfile(s) from suite template files.

positional arguments:
  image       Path to an image directory containing Dockerfile.template.
  suite       Specifies a list of suites to work on.

optional arguments:
  -h, --help  show this help message and exit
```

**publish.py**:
```
usage: publish.py [-h] [--rm] [--no-cache] [--no-push]
                  [image] [suite [suite ...]]

Generate Dockerfile(s) from suite template files.

positional arguments:
  image       Path to an image directory containing Dockerfile.template.
  suite       Specifies a list of suites to work on.

optional arguments:
  -h, --help  show this help message and exit
  --rm        Remove intermediate containers after a successful build.
  --no-cache  Do not use cache when building the image.
  --no-push   Do not use cache when building the image.
```
