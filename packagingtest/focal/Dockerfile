FROM buildpack-deps:focal

ENV container docker
ENV TERM xterm

# Make noninteractive setting permanent
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections -v

RUN apt-get -y update

# Enable remote pubkey access
RUN mkdir /root/.ssh && chmod 700 /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdCmmPjsOBWRXc+PKdgDRrsciNjp25zTacyz8Gdkln2ma046brOYXAphhp/85DKgHtANBBt3cl4+HnpDbmAfyq2qZT7hWzAbMxtq0Sj+yyFyUdreXoe4gEKyxpV6o8p/R/XzEcawvqX/vFc5EIFmvTdamxZs9DQmOE5AZMzUB18Kerkrb0/arUcZ8iMi9Ng9a18avow+7oUFZ6Oub7ISz/dkIRojaKO/2paJZ4p+v7ZLn7Hq8TUeBkgAlx872oh8J8linhIq17zK6x4MGL8qiurp2hnfe0cuCxwcsYGy+4DfK51+E2vks6FprCIfF5hIdz26euPn67/YpM0F0b5nXF busybee@drone" >> /root/.ssh/authorized_keys

# Create busybee credentials and make busybee pkey available for root
COPY busybee*  /root/.ssh/
RUN chmod 600 /root/.ssh/busybee

RUN apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd

# install locales package and set default locale to 'UTF-8' for the test execution environment
RUN apt-get -y install locales && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# 1. small fix for SSH in ubuntu 13.10 (that's harmless everywhere else)
# 2. permit root logins and set simple password password and pubkey
# 3. change requiretty to !requiretty in /etc/sudoers
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
        sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
        sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
        sed -ri 's/requiretty/!requiretty/' /etc/sudoers && \
        echo 'root:docker.io' | chpasswd

# install core software for packaging and ssh communication
RUN echo -e "#!/bin/sh\nexit 101\n" > /usr/sbin/policy-rc.d && \
    apt-get -y install gdebi-core sshpass cron netcat net-tools iproute2

# install apt https transport so apt sources can be added that refernece https:// URLs
RUN apt-get -y install apt-transport-https ca-certificates

# install netbase package (includes /etc/protocols and other files we rely on)
RUN apt-get -y install netbase

RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;

RUN systemctl set-default multi-user.target

# The base Ubuntu 18.04 image contains a file that excludes all documentation
# from being installed by packages. Specifically /usr/share/doc/*
# This exclusion prevents our nginx config from being installed in the 'st2' package:
# /usr/share/doc/st2/conf/nginx/st2.conf
# This step removes the exclusion configuration so documentation of all future packages
# will be installed.
RUN rm -rf /etc/dpkg/dpkg.cfg.d/excludes

COPY setup.sh /sbin/

RUN systemctl preset ssh;

# we can have ssh
EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/sbin/init" ]
