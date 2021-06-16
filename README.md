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

Installing the worker queue on a machine is as easy as running the setup script: `sudo ./setup.sh REDIS_PASSWORD VQUEUE_ADDRESS`

This installs Docker and creates a systemd service that runs the worker queue with the given parameters.

VQUEUE_ADDRESS is the `xxx.vqueue.net` address configured in Valohai's AWS Route 53 and REDIS_PASSWORD is an agreed-upon password for Redis.
