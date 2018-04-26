#!/usr/bin/env bash

# Variables needed:
# $SERVER_NAME

# SERVER_CERT => /etc/nginx/certs/cert.pem
# SERVER_KEY  => /etc/nginx/certs/cert.key

if [[ ! $SERVER_NAME ]] || [[ ! -e "/etc/nginx/certs/cert.pem" ]] || [[ ! -e "/etc/nginx/certs/cert.key" ]]; then
    >&2 echo -e "ERROR!! Empty variable \$SERVER_NAME or SSL cert or key not found"
    exit 1
fi

# Set pushprox-proxy values if found or apply default ones
SCRAPE_MAX=${SCRAPE_MAX:-"5m"}
SCRAPE_DEFAULT=${SCRAPE_DEFAULT:-"15s"}
REGISTRATION_TIMEOUT=${REGISTRATION_TIMEOUT:-"5m"}
LOG_LEVEL=${LOG_LEVEL:-"info"}

#usage: pushprox-proxy [<flags>]
#
#Flags:
#  -h, --help                     Show context-sensitive help (also try --help-long and --help-man).
#      --scrape.max-timeout=5m    Any scrape with a timeout higher than this will have to be clamped to this.
#      --scrape.default-timeout=15s
#                                 If a scrape lacks a timeout, use this value.
#      --registration.timeout=5m  After how long a registration expires.
#      --web.listen-address=":8080"
#                                 Address to listen on for proxy and client requests.
#      --log.level=info           Only log messages with the given severity or above. One of: [debug, info, warn,

/pushprox-proxy --scrape.max-timeout="$SCRAPE_MAX" --scrape.default-timeout="$SCRAPE_DEFAULT" --registration.timeout="$REGISTRATION_TIMEOUT" --log.level="$LOG_LEVEL" --web.listen-address="localhost:8080" &
# Build nginx config if pushprox-proxy started correctly
if [[ $? == 0 ]]; then
   envsubst \$SERVER_NAME < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && \
   cat /etc/nginx/nginx.conf && \
   nginx -g 'daemon off;' 2>&1
fi
