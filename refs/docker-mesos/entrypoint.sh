#!/bin/bash

set -eo pipefail

if [ "$1" == "mesos-master" ]; then
    shift
    exec su-exec mesos mesos-master "$@"

elif [ "$1" == "mesos-agent" ]; then
    shift
    exec su-exec mesos mesos-agent "$@"
fi

exec "$@"