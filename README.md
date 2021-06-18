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

Installing the worker queue on a machine is as easy as running: `curl https://raw.githubusercontent.com/valohai/worker-queue/main/host/setup.sh | sudo bash -s -- QUEUE_ADDRESS REDIS_PASSWORD`

This installs Docker and creates a systemd service that runs the worker queue with the given parameters.

QUEUE_ADDRESS is the `xxx.vqueue.net` address configured in Valohai's AWS Route 53 and REDIS_PASSWORD is an agreed-upon password for Redis.

Running the above is equal to running the setup script directly: `sudo ./setup.sh QUEUE_ADDRESS REDIS_PASSWORD`
