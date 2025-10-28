#!/bin/bash

flavor="$1"

if [[ -z "$flavor" ]]; then
  flavors="$(find packagingbuild -name Dockerfile -print0 | xargs -0 dirname | xargs basename | paste -sd '|' -)"
  echo "Usage: $0 [$flavors]"
  exit 1
fi

date_suffix=$(date +%Y-%m-%d)

(cd "packagingbuild/${flavor}"; docker build -t "stackstorm/packagingbuild:${flavor}" -t "stackstorm/packagingbuild:${flavor}-${date_suffix}" .) || exit -1
(cd "packagingtest/${flavor}"; docker build -t "stackstorm/packagingtest:${flavor}-systemd" -t "stackstorm/packagingtest:${flavor}-systemd-${date_suffix}" .) || exit -1
