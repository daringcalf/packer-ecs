#!/usr/bin/env bash
set -e

echo "### Configuring Docker Volume Storage ###"
sudo mkdir -p /data
sudo mkfs.xfs -L docker /dev/xvdcy
echo -e "LABEL=docker\t/data\t\txfs\tdefaults,noatime\t0\t0" | sudo tee -a /etc/fstab
sudo mount -a

