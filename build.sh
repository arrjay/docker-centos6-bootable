#!/usr/bin/env bash

set -ex

[ "${DOCKER_SINK}" ] && {
  docker pull "${DOCKER_SINK}/${PRODUCT}"
  docker tag  "${DOCKER_SINK}/${PRODUCT}" "upstream"
}

set -u

for d in dockerfiles/*/Dockerfile ; do
  image=${d#dockerfiles/}
  image=${image%/Dockerfile}
  docker build -t "build/${image}" -f "${d}" .
done
