#!/bin/bash

if [ -z "$REDIS_PASSWORD" ]; then
    >&2 echo "REDIS_PASSWORD not set"
    exit 1
fi

# Make bash more strict about errors
#set -euo pipefail

if [ -z "$QUEUE_ADDRESS" ]; then
    echo "QUEUE_ADDRESS not. Skipping self-signed certificate"

    sed -i "/FILL_ADDRESS/s/^/# /" /etc/redis/redis.conf
    sed -i '/^[^#]/ s/\(^.*tls-port 63790.*$\)/#\ \1/' /etc/redis/redis.conf
    sed -i '/^[^#]/ s/\(^.*tls-auth-clients.*$\)/#\ \1/' /etc/redis/redis.conf
    sed -i "s|port 0|port 6379|" /etc/redis/redis.conf
else
    if test ! -d /var/lib/acme/live/"$QUEUE_ADDRESS"; then
        acmetool want "$QUEUE_ADDRESS"
    fi

    # acmetool has a cronjob to reconcile the SSL certificates,
    # so we start the cron daemon
    /usr/sbin/cron

    sed -i "s|FILL_ADDRESS|$QUEUE_ADDRESS|" /etc/redis/redis.conf
    sed -i "s|# tls-port 63790|tls-port $REDIS_PORT|" /etc/redis/redis.conf
fi

sed -i "s|# requirepass foobared|requirepass $REDIS_PASSWORD|" /etc/redis/redis.conf

exec redis-server /etc/redis/redis.conf
