# Valohai Worker Queue

This repository contains a Dockerfile for building the Valohai Worker queue and scripts to deploy the queue.

The Docker image built is based on the official Ubuntu 20.04 image and contains:

- Redis (version 6+)
- acmetool (modified for ACMEv2 support)
- a startup script that wants the specified SSL certificate and runs Redis with the given password

## Bulding and Publishing

Build: `./build.sh`

Publish: `./publish.sh`
