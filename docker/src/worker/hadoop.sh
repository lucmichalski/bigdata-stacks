#!/usr/bin/env bash

THIS_DIR=`dirname "$0"`
source ${THIS_DIR}/../common/hadoop.sh

configure_hadoop
start_worker
