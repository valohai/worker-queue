#!/bin/bash

if test "$#" -ne 2; then
    >&2 echo "Invalid amount of parameters, QUEUE_ADDRESS and REDIS_PASSWORD required"
    exit 1
fi

QUEUE_ADDRESS=$1
REDIS_PASSWORD=$2
DOCKER_IMAGE=valohai/worker-queue:latest

# Upgrade system

apt-get update
apt-get upgrade -y

# Install Docker

if test ! -f /usr/share/keyrings/docker-archive-keyring.gpg; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
fi

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Pull worker queue image

docker pull $DOCKER_IMAGE

# Setup a systemd service for automatic restarts

cat << EOM > /etc/systemd/system/worker-queue.service
[Unit]
Description=Valohai Worker Queue
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm \
                              --name %n \
                              --network host \
                              --mount source=acme,target=/var/lib/acme \
                              --mount source=redis,target=/var/lib/redis \
                              $DOCKER_IMAGE $QUEUE_ADDRESS $REDIS_PASSWORD
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
EOM

systemctl enable worker-queue
systemctl start worker-queue
