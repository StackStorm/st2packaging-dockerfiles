#!/bin/bash

set -eux

for bp in $(find buildpack -name Dockerfile); do
	path=$(dirname $bp)
	flavor=$(basename $path)
	(cd $path; docker build -t stackstorm/buildpack:$flavor .) || exit -1
done

for pb in $(find packagingbuild -name Dockerfile); do
	path=$(dirname $pb)
	flavor=$(basename $path)
	(cd $path; docker build -t stackstorm/packagingbuild:$flavor .) || exit -1
done

for pt in $(find packagingtest -name Dockerfile); do
	path=$(dirname $pt)
	flavor=$(basename $path)
	(cd $path; docker build -t stackstorm/packagingtest:$flavor .) || exit -1
done
