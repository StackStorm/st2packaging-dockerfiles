#!/bin/bash

flavor="$1"

if [[ -z "$flavor" ]]; then
  flavors="$(find packagingbuild -name Dockerfile -print0 | xargs -0 dirname | xargs basename | paste -sd '|' -)"
  echo "Usage: $0 [$flavors]"
  exit 1
fi

(cd "packagingbuild/${flavor}"; docker build -t "stackstorm/packagingbuild:${flavor}" .) || exit 1
(cd "packagingtest/${flavor}"; docker build -t "stackstorm/packagingtest:${flavor}" .) || exit 1
