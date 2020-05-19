#!/usr/bin/env bash

THIS_DIR=`dirname "$0"`
source ${THIS_DIR}/../common/kafka.sh

config_broker
start_broker
