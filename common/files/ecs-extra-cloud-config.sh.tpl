#!/usr/bin/env bash
set -e

# create public volume
mkdir -p /data/public && chown -R 1000:1000 /data/public

# Set HTTP Proxy URL if provided
if [ -n $PROXY_URL ]
then
  echo export HTTPS_PROXY=$PROXY_URL >> /etc/sysconfig/docker
  echo HTTPS_PROXY=$PROXY_URL >> /etc/ecs/ecs.config
  echo NO_PROXY=169.254.169.254,169.254.170.2,/var/run/docker.sock >> /etc/ecs/ecs.config
  echo HTTP_PROXY=$PROXY_URL >> /etc/awslogs/proxy.conf
  echo HTTPS_PROXY=$PROXY_URL >> /etc/awslogs/proxy.conf
  echo NO_PROXY=169.254.169.254 >> /etc/awslogs/proxy.conf
fi

# Start services
sudo systemctl enable ecs.service
sudo systemctl start ecs.service

# Health check
# Loop until ECS agent has registered to ECS cluster
sudo yum install jq -y

echo "Checking ECS agent is joined to ${ECS_CLUSTER}"
until [[ "$(curl --fail --silent http://localhost:51678/v1/metadata | jq '.Cluster // empty' -r -e)" == ${ECS_CLUSTER} ]]
  do printf '.'
  sleep 5
done
echo "ECS agent successfully joined to ${ECS_CLUSTER}"
