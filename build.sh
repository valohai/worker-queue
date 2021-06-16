#!/bin/bash

if test ! -f docker/acmetool/acmetool-v2-beta-linux; then
    wget https://valohai-cfg.s3.amazonaws.com/pub/acmetool-v2-beta-linux --directory-prefix=docker/acmetool/
fi

chmod +x docker/acmetool/acmetool-v2-beta-linux

docker build -t valohai/worker-queue:latest docker
