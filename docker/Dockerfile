FROM ubuntu:20.10

# Update base

RUN apt-get update && apt-get upgrade -y

# Install redis

COPY redis/redis.sources /etc/apt/sources.list.d/redis.sources

COPY redis/redis-archive-keyring.asc /usr/local/share/keyrings/redis-archive-keyring.asc

RUN apt-get update && apt-get install redis-server -y

COPY redis/redis.conf /etc/redis/redis.conf

# Install acmetool

RUN apt-get install -y ca-certificates cron libcap2

COPY acmetool/acmetool-v2-beta-linux /usr/bin/acmetool

COPY acmetool/acmetool-responses.yaml /var/lib/acme/conf/responses

RUN acmetool quickstart

# Install worker queue startup script

COPY run_worker_queue.sh /usr/local/bin/run_worker_queue.sh

ENTRYPOINT ["run_worker_queue.sh"]
