FROM st2
LABEL com.stackstorm.service.provides="client"

ADD ./config /.st2/config
ENV ST2_CONFIG_FILE /.st2/config

CMD ["st2"]
