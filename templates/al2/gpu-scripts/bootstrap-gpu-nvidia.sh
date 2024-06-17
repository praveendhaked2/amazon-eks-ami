#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o xtrace

if ! gpu-ami-util has-nvidia-devices; then
  echo >&2 "no NVIDIA devices are present, nothing to do!"
  exit 0
fi

# add 'nvidia' runtime to containerd config, and set it as the default
# otherwise, all Pods need to speciy the runtimeClassName
nvidia-ctk runtime configure --runtime=containerd --set-as-default

# restart containerd to pick up the changes
systemctl restart containerd
