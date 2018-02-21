FROM buildpack-deps:trusty

# Enable remote pubkey access
RUN mkdir /root/.ssh && chmod 700 /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdCmmPjsOBWRXc+PKdgDRrsciNjp25zTacyz8Gdkln2ma046brOYXAphhp/85DKgHtANBBt3cl4+HnpDbmAfyq2qZT7hWzAbMxtq0Sj+yyFyUdreXoe4gEKyxpV6o8p/R/XzEcawvqX/vFc5EIFmvTdamxZs9DQmOE5AZMzUB18Kerkrb0/arUcZ8iMi9Ng9a18avow+7oUFZ6Oub7ISz/dkIRojaKO/2paJZ4p+v7ZLn7Hq8TUeBkgAlx872oh8J8linhIq17zK6x4MGL8qiurp2hnfe0cuCxwcsYGy+4DfK51+E2vks6FprCIfF5hIdz26euPn67/YpM0F0b5nXF busybee@drone" >> /root/.ssh/authorized_keys

# Create busybee credentials and make busybee pkey available for root
COPY busybee*  /root/.ssh/
RUN chmod 600 /root/.ssh/busybee

RUN DEBIAN_FRONTEND=noninteractive && apt-get -y update && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd

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
    DEBIAN_FRONTEND=noninteractive && apt-get -y update && \
    apt-get -y install gdebi-core sshpass cron \
      netcat net-tools

# install netbase package (includes /etc/protocols and other files we rely on)
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get -y install netbase

COPY init-fake.conf /etc/init/fake-container-events.conf

# undo some leet hax of the base image
RUN echo -e "#!/bin/sh\nexit 101\n" > /usr/sbin/policy-rc.d && \
  rm /sbin/initctl; dpkg-divert --rename --remove /sbin/initctl

# generate a nice UTF-8 locale for our use
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# remove some pointless services
RUN /usr/sbin/update-rc.d -f ondemand remove; \
  for f in \
    /etc/init/u*.conf \
    /etc/init/mounted-dev.conf \
    /etc/init/mounted-proc.conf \
    /etc/init/mounted-run.conf \
    /etc/init/mounted-tmp.conf \
    /etc/init/mounted-var.conf \
    /etc/init/hostname.conf \
    /etc/init/networking.conf \
    /etc/init/tty*.conf \
    /etc/init/plymouth*.conf \
    /etc/init/hwclock*.conf \
    /etc/init/module*.conf\
  ; do \
    dpkg-divert --local --rename --add "$f"; \
  done; \
  echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab


# let Upstart know it's in a container
ENV container docker

# we can have SSH
EXPOSE 22

# pepare for takeoff
CMD ["/sbin/init"]
