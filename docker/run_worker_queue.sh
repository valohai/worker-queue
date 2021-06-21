#!/bin/bash

if [ -z "$QUEUE_ADDRESS" ]; then
    >&2 echo "QUEUE_ADDRESS not set"
    exit 1
fi

if [ -z "$REDIS_PASSWORD" ]; then
    >&2 echo "REDIS_PASSWORD not set"
    exit 1
fi

if test ! -d /var/lib/acme/live/"$QUEUE_ADDRESS"; then
    acmetool want "$QUEUE_ADDRESS"
fi

# acmetool has a cronjob to reconcile the SSL certificates,
# so we start the cron daemon
/usr/sbin/cron

sed -i "s|# requirepass foobared|requirepass $REDIS_PASSWORD|" /etc/redis/redis.conf
sed -i "s|FILL_ADDRESS|$QUEUE_ADDRESS|" /etc/redis/redis.conf

exec redis-server /etc/redis/redis.conf
