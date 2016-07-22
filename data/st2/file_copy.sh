# DATASTORE_DIR is given for running

export AMPQ_URL="amqp://guest:guest@rabbitmq:5672/"
export ST2_API_HOST=$HOST_IP

cp $DATASTORE_DIR/htpasswd /etc/st2/htpasswd
