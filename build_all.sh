#!/bin/bash

set -eux

for pb in $(find packagingbuild -name Dockerfile); do
	path=$(dirname $pb)
	flavor=$(basename $path)
	(cd $path; docker build -t stackstorm/packagingbuild:$flavor .) || exit -1
done

for pt in $(find packagingtest -name Dockerfile); do
	path=$(dirname $pt)
	flavor=$(basename $path)
	if [[ "$flavor" == "systemd" ]]; then
		path=$(dirname $pt)
		flavor=$(basename $(dirname $path))
	fi
	(cd $path; docker build -t stackstorm/packagingtest:$flavor .) || exit -1
done
