#!/bin/bash

if [ ! -f /etc/nginx/ssl/inception.key ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/C=FR/ST=Rhone/L=Lyon/O=42/OU=42/CN=lserodon.42.fr/UID=lserodon"
fi

exec nginx -g "daemon off;"