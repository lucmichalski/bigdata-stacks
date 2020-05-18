# Docker Splunk + CollectD

Based on these Docker images:

* [Splunk](https://hub.docker.com/r/splunk/splunk/)
* [collectD](https://github.com/jwiebalk/docker-collectd-receiver)(Not based on official image)
## Requirements

### Host setup

1. Install [Docker](https://www.docker.com/community-edition#/download) version **1.10.0+**
2. Install [Docker Compose](https://docs.docker.com/compose/install/) version **1.6.0+**
3. Clone this repository

## Usage

### Initial Setup

1. Use `uuidgen` to generate a Splunk compatible HEC token

```console
export SPLUNK_TOKEN=`uuidgen | tr '[:upper:]' '[:lower:]'`
```

2. Add this token to the SPLUNK_TOKEN entry in the `.env`
3. Configure a password for Splunk in the `.env`
4. Add the SPLUNK_TOKEN to the inputs.conf using `sed -i "s/{{SPLUNK_TOKEN}}/$SPLUNK_TOKEN/g" splunk/splunk_httpinput/inputs.conf`

### Bringing up the stack

1. Run `docker-compose build` first to inject the environment variables from the `.env` and the updated `splunk/splunk_httpinput/inputs.conf`

2. Start the stack in detached mode:

```console
$ docker-compose up -d
```

### Ports exposed

By default, the stack exposes the following ports:
* 5000: Syslog TCP input
* 8088: Splunk write_http Listener
* 8000: Splunk Frontend
* 25826: collectD input
