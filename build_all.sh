#!/bin/bash

set -eux

date_suffix=$(date +%Y-%m-%d)

for pb in $(find packagingbuild -name Dockerfile); do
    path=$(dirname $pb)
    flavor=$(basename $path)
    (cd $path; docker build -t "stackstorm/packagingbuild:${flavor}" -t "stackstorm/packagingbuild:${flavor}-${date_suffix}" .) || exit -1
done

for pt in $(find packagingtest -name Dockerfile); do
    path=$(dirname $pt)
    flavor=$(basename $path)
    (cd $path; docker build -t "stackstorm/packagingtest:${flavor}-systemd" -t "stackstorm/packagingtest:${flavor}-systemd-${date_suffix}" .) || exit -1
done
