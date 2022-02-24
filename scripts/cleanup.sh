#!/usr/bin/env bash
echo "### Performing final clean-up tasks ###"
sudo systemctl stop ecs.service
sudo systemctl disable ecs.service
sudo docker system prune -f -a
sudo systemctl stop docker.socket
sudo systemctl stop docker.service
sudo systemctl disable docker 
#sudo rm -rf /var/log/docker /var/log/ecs/*
sudo rm -rf /var/log/ecs/*
