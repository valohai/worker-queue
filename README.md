# Valohai Worker Queue

This repository contains a Dockerfile for building the Valohai Worker queue and scripts to deploy the queue.

The Docker image built is based on the official Ubuntu 20.04 image and contains:

- Redis (version 6+)
- acmetool (modified for ACMEv2 support)
- a startup script that wants the specified SSL certificate and runs Redis with the given password

## Bulding and Publishing

Build: `./build.sh`

Publish: `./publish.sh`

## Installation

> :warning: The worker queue host machine needs to have port 80 open to the internet and port 63790 open to Valohai (roi) and workers (peon)!

Installing the worker queue on a machine is as easy as running: `curl https://raw.githubusercontent.com/valohai/worker-queue/main/host/setup.sh | sudo QUEUE_ADDRESS=your-queue-address-here REDIS_PASSWORD=your-redis-password-here REDIS_PORT=redis-tls-port bash`

This installs Docker and creates a systemd service that runs the worker queue with the given parameters.

Replace your-queue-address-here with the `xxx.vqueue.net` address configured in Valohai's AWS Route 53 and your-redis-password-here with an agreed-upon password for Redis.

Running the above is equal to running the setup script directly: `sudo QUEUE_ADDRESS=your-queue-address-here REDIS_PASSWORD=your-redis-password-here ./setup.sh`

### Manual Setup

If you want to install the worker queue without running the setup script `setup.sh` at all, here are the steps required:

- Prepare a Linux host machine with Docker installed
- Run `docker pull valohai/worker-queue:latest`
- Copy `host/worker-queue.service` from this repository to `/etc/systemd/system/worker-queue.service`
- Replace the following values in `etc/systemd/system/worker-queue.service`: `$QUEUE_ADDRESS` with your `xxx.vqueue.net` address and `$REDIS_PASSWORD` with an agreed-upon password for Redis
- Run `systemctl enable worker-queue`
- Run `systemctl start worker-queue`
