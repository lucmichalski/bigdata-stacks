# Flume docker image
Build a flume docker image on Alpine Linux.

## Version
- flume: 1.6.0

## Exposed ports
- source port: 44444

## Building the image       
- ``docker build -t pkeropen3/flume_alpine:1.6.0 .``

## Running
- ``docker run --env FLUME_AGENT_NAME=docker --volume /tmp/config.conf:/opt/flume-config/flume.conf --detach pkeropen3/flume_alpine:latest ``

## Usage
Start a cluster with zookeeper and flume:

- ``docker-compose up -d ``

Destroy a cluster:

- ``docker-compose stop``

