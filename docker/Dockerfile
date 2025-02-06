FROM debian:bookworm-slim

# Update base, install redis and dependencies

RUN \
    apt-get update -q && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends ca-certificates cron libcap2 nano redis-server && \
    rm -rf /var/lib/apt/lists/* && \
    find /var/cache -name '*-old' -print -delete && \
    # check that we have the right version of redis
    redis-server --version | grep v=7

COPY redis/redis.conf /etc/redis/redis.conf

# Install acmetool

COPY acmetool/acmetool-v2-beta-linux /usr/bin/acmetool

COPY acmetool/acmetool-responses.yaml /var/lib/acme/conf/responses

RUN acmetool quickstart

COPY redis/tls-reload /usr/libexec/acme/hooks/tls-reload

# Install worker queue startup script

COPY run_worker_queue.sh /usr/local/bin/run_worker_queue.sh

ENTRYPOINT ["run_worker_queue.sh"]
