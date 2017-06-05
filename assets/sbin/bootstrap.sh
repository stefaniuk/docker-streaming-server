#!/bin/bash
set -e

mkdir -p /var/log/nginx
mkdir -p /tmp/{hls,dash}
chown -R $SYSTEM_USER:$SYSTEM_USER \
    /usr/local/nginx \
    /var/log/nginx \
    /tmp/{hls,dash}

tail -F /var/log/nginx/access.log > /dev/stdout 2> /dev/null &
tail -F /var/log/nginx/error.log > /dev/stderr 2> /dev/null &
