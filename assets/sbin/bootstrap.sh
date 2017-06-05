#!/bin/bash
set -e

mkdir -p /tmp/{hls,dash}
mkdir -p /var/log/nginx
chown -R $SYSTEM_USER:$SYSTEM_USER /var/log/nginx

tail -F /var/log/nginx/access.log > /dev/stdout 2> /dev/null &
tail -F /var/log/nginx/error.log > /dev/stderr 2> /dev/null &
