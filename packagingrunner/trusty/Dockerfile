FROM quay.io/dennybaa/droneruby:trusty-rbenv

# Additional software (needed for RSpec, serverspec)
RUN DEBIAN_FRONTEND=noninteractive && apt-get -y update && \
    apt-get -y install netcat && apt-get -y clean

ADD Gemfile /root/Gemfile

RUN ~/.rbenv/bin/rbenv exec bundle --gemfile=/root/Gemfile

CMD /bin/bash
