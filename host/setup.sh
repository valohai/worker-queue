#!/bin/bash

if [ -z "$REDIS_PASSWORD" ]; then
    >&2 echo "REDIS_PASSWORD not set"
    exit 1
fi

if [ -z "$DOCKER_IMAGE" ]; then
    DOCKER_IMAGE=valohai/worker-queue:latest
else
    DOCKER_IMAGE=$DOCKER_IMAGE
fi

# Make bash more strict about errors
set -euo pipefail

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
StartLimitIntervalSec=0
StartLimitBurst=3

[Service]
Restart=always
RestartSec=300
ExecStart=/usr/bin/docker run --rm \
                              --name %n \
                              --network host \
                              --mount source=acme,target=/var/lib/acme \
                              --mount source=redis,target=/var/lib/redis \
                              -e QUEUE_ADDRESS=$QUEUE_ADDRESS \
                              -e REDIS_PASSWORD=$REDIS_PASSWORD \
                              valohai/worker-queue:latest
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
EOM

systemctl enable worker-queue
systemctl start worker-queue
