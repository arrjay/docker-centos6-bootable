#!/usr/bin/env bash

set -ex

[ "${DOCKER_SINK}" ] && {
  docker pull "${DOCKER_SINK}/centos:7"
  docker tag  "${DOCKER_SINK}/centos:7" "centos:7"
}

set -u

for d in dockerfiles/*/Dockerfile ; do
  image=${d#dockerfiles/}
  image=${image%/Dockerfile}
  docker build -t "build/${image}" -f "${d}" .
done
