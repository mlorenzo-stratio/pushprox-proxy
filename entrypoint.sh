#!/usr/bin/env bash

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

/pushprox-proxy --scrape.max-timeout="$SCRAPE_MAX" --scrape.default-timeout="$SCRAPE_DEFAULT" --registration.timeout="$REGISTRATION_TIMEOUT" --log.level="$LOG_LEVEL" --web.listen-address=":7070"
