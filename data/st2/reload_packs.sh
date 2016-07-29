#!/bin/sh
set -e

if [ "$ST2_SERVICE" != "st2api" ]; then
  echo "Not running reload pack script, not st2api."
  exit 0
fi
 

echo "Running reload pack script on st2api."

STATE_FILE="/st2_packs_sha1sum"

ST2_PACKS_DIR="$1"

if [ -s "$STATE_FILE" ]; then
  OLD_SHA1SUM=`cat $STATE_FILE`
fi

ST2_PACKS_SHA1SUM="$(find $ST2_PACKS_DIR -type f -print0 | sort -z | xargs -0 sha1sum | sha1sum | cut -d' ' -f1)"


if [ "$OLD_SHA1SUM" = "$ST2_PACKS_SHA1SUM" ]; then
  echo "No change in packs dir detected"
else
  echo "Change in packs dir ($ST2_PACKS_DIR) detected"
  st2ctl reload
  echo "$ST2_PACKS_SHA1SUM" > $STATE_FILE
  echo "Packs reloaded."
fi

