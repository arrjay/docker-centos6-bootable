#!/usr/bin/env bash

# this program is designed to be called exclusively from udev ;)

# called with /dev/nvmeXnX
op_read_nvme_ec2_map () {
  local line dev map prefix
  dev="${1}"
  # we do this because expressing removal of / in shell otherwise is maddening
  prefix='/dev/'
  while IFS= read -r line ; do
    case "${line}" in
      # vendor page 0 contains the mapping
      0000:*)				# 0000: 73 64 61 31 20 20 20 20 20 20 20 20 20 20 20 20 "/dev/sda1......."
        map="${line##* }"		# "/dev/sda1......."
        map="${map/${prefix}/}"		# "sda1......."
        map="${map//[^A-Za-z0-9]/}"	# sda1
      ;;
    esac
  done <<< "$(/usr/sbin/nvme id-ctrl -v "${dev}")"
  # do we actually have a mapping after that?
  [ "${map}" ] || exit 1
  echo -n "${map}"
}

# called with vol00e573b990d74b21e
op_shorten_aws_serial () {
  local serial short
  serial="${1}"
  short="${serial#vol}"
  [ "${short}" ] || exit 1
  echo -n "${short}"
}

# called with ?
op_diskentry_getminor () {
  local diskent diskmin
  diskent="${1}"
  diskmin="${diskent#*:}"
  [ "${diskmin}" ] || exit 1
  echo -n "${diskmin}"
}

case "${1}" in
  nvme_ec2_launch_map) op_read_nvme_ec2_map  "${2}" ;;
  shorten_volid)       op_shorten_aws_serial "${2}" ;;
  getdiskmin)          op_diskentry_getminor "${2}" ;;
  *) exit 1 ;;
esac
