#!/usr/bin/env bash

set -o pipefail
set -o nounset
set -o errexit

sudo yum upgrade -y

sudo yum groupinstall 'Development Tools' -y

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
distribution='rhel7'
ARCH=$( /bin/arch )
sudo yum-config-manager --add-repo http://developer.download.nvidia.com/compute/cuda/repos/$distribution/${ARCH}/cuda-$distribution.repo
sudo yum clean expire-cache

sudo mkdir -p /etc/dkms
sudo echo "MAKE[0]=\"'make' -j2 module SYSSRC=\${kernel_source_dir} IGNORE_XEN_PRESENCE=1 IGNORE_PREEMPT_RT_PRESENCE=1 IGNORE_CC_MISMATCH=1 CC=/usr/bin/gcc10-gcc\"" | sudo tee /etc/dkms/nvidia.conf
sudo yum clean all
sudo yum -y install kmod-nvidia-latest-dkms nvidia-driver-latest-dkms
sudo yum -y install cuda-drivers-fabricmanager cuda libcudnn8-devel

sudo mkdir -p /etc/yum.repos.d
sudo curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo

sudo yum install -y nvidia-container-toolkit

nvidia-smi
