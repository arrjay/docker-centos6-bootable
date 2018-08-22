#!/usr/bin/env bash

[ "${ARTIFACTORY_PASSWORD}" ] && {
  docker login -u "${ARTIFACTORY_USERNAME}" -p "${ARTIFACTORY_PASSWORD}" docker.palantir.build
}

set -ex

PRODUCT="${PRODUCT/:/-}"

ts=$(date +%s)

for img in $(docker images "build/*" --format "{{.Repository}}:{{.Tag}}") ; do
  dest="${img#build/}"
  dest="${dest%:latest}"
  case "${dest}" in [0-9]*) continue ;; esac
  docker tag "${img}" "${DOCKER_SINK}/${PRODUCT}-vm-bootable:${dest}"
  docker tag "${img}" "${DOCKER_SINK}/${PRODUCT}-vm-bootable:${dest}.${ts}"
  [ "${NOPUSH}" ] || {
    docker push "${DOCKER_SINK}/${PRODUCT}-vm-bootable:${dest}"
    docker push "${DOCKER_SINK}/${PRODUCT}-vm-bootable:${dest}.${ts}"
  }
done

