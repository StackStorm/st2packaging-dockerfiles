
export RABBITMQ_URL="${AMQP_URL:-amqp://guest:guest@rabbitmq:5672/}"
export MONGO_HOST="${DB_HOST:-mongo}"
export MONGO_PORT="${DB_PORT:-27017}"
export ST2_API_URL="https://${PUBLIC_ADDRESS}/api/"
run_confd
echo -e "\n\nRunning fake entrypoint!\n\n"
