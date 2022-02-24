#!/usr/bin/env bash
echo "### Performing final clean-up tasks ###"
sudo docker stop ecs-agent 
sudo docker system prune -f -a
sudo systemctl stop docker 
sudo systemctl disable docker 
#sudo rm -rf /var/log/docker /var/log/ecs/*
sudo rm -rf /var/log/ecs/*

