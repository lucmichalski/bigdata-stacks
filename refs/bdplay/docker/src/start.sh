#!/usr/bin/env bash

THIS_DIR=`dirname "$0"`

export HADOOP_CLASSPATH=`hadoop classpath`

if [[ "$1" = "help" ]]; then
    echo "Usage: $(basename "$0") (master|worker|help)"
    exit 0

elif [[ "$1" = "master" ]]; then
    ls ${THIS_DIR}/master/*.sh | xargs -L 1 gosu bdplay bash
    shift 1

elif [[ "$1" = "worker" ]]; then
    ls ${THIS_DIR}/worker/*.sh | xargs -L 1 gosu bdplay bash
    shift 1

fi

exec "$@"
