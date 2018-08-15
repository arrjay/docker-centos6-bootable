#!/usr/bin/env bash

set -ex

ts=$(date +%s)

for img in $(docker images "build/*" --format "{{.Repository}}:{{.Tag}}") ; do
  dest="${img#build/}"
  dest="${dest%:latest}"
  case "${dest}" in [0-9]*) continue ;; esac
  docker tag "${img}" "${DOCKER_SINK}/centos-7-vm-bootable:${dest}"
  docker tag "${img}" "${DOCKER_SINK}/centos-7-vm-bootable:${dest}.${ts}"
  [ "${NOPUSH}" ] || {
    docker push "${DOCKER_SINK}/centos-7-vm-bootable:${dest}"
    docker push "${DOCKER_SINK}/centos-7-vm-bootable:${dest}.${ts}"
  }
done

