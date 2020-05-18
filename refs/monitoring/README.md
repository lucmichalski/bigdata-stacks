# Monitoring Stack
Full stack of tools for monitoring.

This stack is composed by:

- [Netdata](https://github.com/firehol/netdata):
`Real Time Monitoring` - Visualise real time system status
- [Prometheus](https://prometheus.io/)
`Data Base` - Store collected metrics
- [Docker](https://www.docker.com/)
`Container` - Base container solution
- [cAdvisor](https://github.com/google/cadvisor)
`Container metrics exporter` - Expose metrics of your running containers
- [Grafana](https://grafana.com/)
`Analytics plataform` - Allow you query and understand collected metrics
- [Node_Exporter](https://github.com/prometheus/node_exporter)
`OS & Hardware metrics exporter` - Expose OS & Hardware metrics
- [AlertManager](https://github.com/prometheus/alertmanager)
`Alerting` - Handle alerts sent by Prometheus
- [Slack](https://slack.com/)
`Communications` - Easy integration between your teammates
- [BlackBox Exporter](https://github.com/prometheus/blackbox_exporter)
`Endpoint Probes` - Probing of multiple endpoints over HTTP, HTTPS, DNS, TCP and ICMP

# Requirements

To execute the steps bellow the following are necessary: 

 - Docker in [Swarm](https://docs.docker.com/engine/swarm/) mode

You can simply run the following to start your standalone [swarm cluster](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/):

```
$ docker swarm init --advertise-addr YOUR_HOST_IP_HERE
Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    YOUR_HOST_IP_HERE:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```
Do not forget to replace "YOUR_HOST_IP_HERE" ;)

# Setup

## Cloning this repo
 
```
cd
# git clone git@github.com:jeskz0rd/monitoring.git
cd monitoring
```

##  Netdata Installation steps

Since version [1.1](https://github.com/Jeskz0rd/monitoring/blob/master/CHANGELOG.md#11---06-07-2018) You can use Netdata as a Container running with the stack as global mode, exposing metrics from all your cluster straight to prometheus.

As described by [titpetric](https://github.com/titpetric) in [additional-notes](https://github.com/titpetric/netdata#additional-notes)

```
You will not get detailed application metrics (mysql, ups, etc.) from other containers or from the 
host if running netdata in a container.
It may be possible to get some of those metrics, but it might not be easy, and most likely not worth it.
For most detailed metrics, netdata needs to share the same environment as the application server
it monitors. This means it would need to run either in the same container (not even remotely practical),
or in the same virtual machine (no containers).
```
If you do not intend to collect this kind of metrics through Netdata the containerized application fulfil the requirements and automates the deployment over your cluster, otherwise follow the steps bellow.

[Install Netdata](https://github.com/firehol/netdata/#installation):
```
# bash <(curl -Ss https://my-netdata.io/kickstart.sh) all
```

### Setup memory de-duplication

[Memory de-duplication](https://github.com/firehol/netdata/wiki/Memory-Deduplication---Kernel-Same-Page-Merging---KSM)

```
# echo 1 >/sys/kernel/mm/ksm/run
# echo 1000 >/sys/kernel/mm/ksm/sleep_millisecs
```

### Setup Netdata Scraper in Prometheus:

```
# vim /conf/prometheus/prometheus.yml
...
- job_name: 'netdata'
    metrics_path: '/api/v1/allmetrics'
    params:
      format: [prometheus]
    honor_labels: true
    scrape_interval: 20s
    static_configs:
         - targets: ['YOUR_NETDATA_IP:19999']
```

### Setup Node Labels

Add the "prom" label to the Prometheus Swarm node.

```
docker node update YOUR_PROMETHEUS_SWARM_NODE --label-add "prom=true"
```

### Setup Grafana Permissions

In Grafana 5.1> the default user id is 472 and as described in [Grafana Documentation](http://docs.grafana.org/installation/docker/) the steps bellow must be done to run it properly. 


```
# docker container run --rm --user root --name grafana_temp -it -v ~/monitoring/volumes/grafana/data:/var/lib/grafana --entrypoint bash grafana/grafana:5.1.3
```

yet in the container you just started run the following:

```
$ chown -R root:root /etc/grafana && \
chmod -R a+r /etc/grafana && \
chown -R grafana:grafana /var/lib/grafana && \
chown -R grafana:grafana /usr/share/grafana && \
exit
``` 

it takes a while changing the permissions...

### Setup HTTP monitoring with Blackbox

Configure Prometheus to scrape http.

Add your http targets in the [prometheus.yml](conf/prometheus/prometheus.yml)

```
####### BLACKBOX MONITORING ########

  - job_name: 'blackbox'
    params:
      module:
      - http_2xx
    scrape_interval: 30s
    scrape_timeout: 10s
    metrics_path: /probe
    scheme: http
    static_configs:
      - targets:
        - http://example.com
        - http://www.example.com
        - http://your.web.app
        - http://your.web.app/check
    ...
```

### Deploy the stack

```
# docker stack deploy -c docker-compose.yml monitoring
```

Check deployed services:
```
# docker service ls

ID                  NAME                           MODE                REPLICAS            IMAGE                           PORTS
ypjvzrdzs760        monitoring_alertmanager        replicated          1/1                 jesk/alertmanager_alpine:1.0    *:9093->9093/tcp
x54ardi5blgn        monitoring_blackbox-exporter   global              1/1                 prom/blackbox-exporter:v0.12.0  *:9115->9115/tcp
nnpqv7k297g4        monitoring_cadvisor            global              1/1                 google/cadvisor:v0.30.0         *:8080->8080/tcp
gpn2qklfmra6        monitoring_grafana             replicated          1/1                 grafana/grafana:5.1.3           *:3000->3000/tcp
7xgth29zggfb        monitoring_netdata             global              1/1                 firehol/netdata:alpine          *:19999->19999/tcp
31q4t856ciua        monitoring_node-exporter       global              1/1                 jesk/node-exporter_alpine:1.0   *:9100->9100/tcp
z2jd4eprumd8        monitoring_prometheus          replicated          1/1                 jesk/prometheus_alpine:1.0      *:9090->9090/tcp
```

Accessing Prometheus interface on browser:
```
http://YOUR_HOST_IP:9090
```

Accessing AlertManager interface on browser:
```
http://YOUR_HOST_IP:9093
```

Accessing Grafana interface on browser:
```
http://YOUR_HOST_IP:3000
user: admin
passwd: admin
```

Accessing Netdata interface on browser:
```
http://YOUR_HOST_IP:19999
```

Accessing Node_exporter metrics on browser:
```
http://YOUR_HOST_IP:9100/metrics
```

Accessing Blackbox_exporter on browser:
```
http://YOUR_HOST_IP:9115
```


Create a channel and add the [API](https://get.slack.help/hc/en-us/articles/215770388-Create-and-regenerate-API-tokens) information about your [Slack account](https://api.slack.com/tokens)

```
# vim /conf/alertmanager/config.yml

route:
    receiver: 'slack'

receivers:
    - name: 'slack'
      slack_configs:
          - send_resolved: true
            username: 'YOUR USERNAME'
            channel: '#YOURCHANNEL'
            api_url: 'INCOMING WEBHOOK'
``` 

# Changelog
All notable changes to this project will be documented in this [file](./CHANGELOG.md).
