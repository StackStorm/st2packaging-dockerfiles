#!/bin/bash

# Copy Gemfile* to WORKING_DIR
cp /root/Gemfile* ./

# If no operation is given run complete suite (default behaviour)
operation="${1:-complete}"

case "$operation" in
build)
  shift
  if [ "$#" -gt 0]; then
    bundle exec rake build "$@"  # should be able to pass st2 or st2mistral as packages_list but can't figure this rake part.
  else
    bundle exec rake build:all
  fi
  ;;
test)
  bundle exec rake setup:all && bundle exec rspec
  ;;
complete)
  bundle exec rake && bundle exec rspec
  ;;
*)
  [ $# -gt 0 ] && exec "$@"
  ;;
esac
