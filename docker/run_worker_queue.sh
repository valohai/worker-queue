#!/bin/bash

if test "$#" -ne 2; then
    >&2 echo "Invalid amount of parameters, QUEUE_ADDRESS and REDIS_PASSWORD required"
    exit 1
fi

QUEUE_ADDRESS=$1
REDIS_PASSWORD=$2

acmetool want $QUEUE_ADDRESS

sed -i "s|# requirepass foobared|requirepass "$REDIS_PASSWORD"|" /etc/redis/redis.conf
sed -i "s|FILL_ADDRESS|"$QUEUE_ADDRESS"|" /etc/redis/redis.conf

exec redis-server /etc/redis/redis.conf
