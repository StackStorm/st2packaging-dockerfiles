#!/bin/bash

# Copy Gemfile* to WORKING_DIR
cp /root/Gemfile* ./

# If no operation is given run complete suite (default behaviour)
operation="${1:-complete}"

case "$operation" in
build)
  bundle exec rake
  ;;
test)
  bundle exec rspec
  ;;
setup_test)
  bundle exec rake setup:all && bundle exec rspec
  ;;
complete)
  bundle exec rake && bundle exec rspec
  ;;
*)
  [ $# -gt 0 ] && exec "$@"
  ;;
esac
