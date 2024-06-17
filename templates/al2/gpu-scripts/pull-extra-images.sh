#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

sudo systemctl start containerd

CUSTOM_IMGS=(
  "787386766641.dkr.ecr.us-east-1.amazonaws.com/ml-entity-relationship:base"
  "787386766641.dkr.ecr.us-east-1.amazonaws.com/domino-video-metadata:base-v2"
)

CACHE_IMGS=(
  ${CUSTOM_IMGS[@]:-}
)

echo "Pulling images ===>"
for img in "${CACHE_IMGS[@]:-}"; do
  nohup sudo /etc/eks/containerd/pull-image.sh "${img}" > /dev/null &
done
echo "image pull completed"
