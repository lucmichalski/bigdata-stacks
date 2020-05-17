# Warp Engine

## Overview


```
  ___ ____     ____        _____
 ____      ___      ______      ___
      _  ___  __    ___        ____
 ___ | |     / /___ __________       ____
     | | /| / / __ `/ ___/ __ \ __    ___
 ___ | |/ |/ / /_/ / /  / /_/ / __  ___
 _   |__/|__/\__,_/_/  / .___/    ___   ____
  __   ___    ____    /_/  ___   __   __
      ____     ___   ____  __   ______
 ____      ___      ______    ____   ____

 WARP ENGINE - Speeding up! your development infraestructure
```

##  Warp Architecture

![Warp Architecture](release/landing/img/warp_architecture.jpg)


## Features

* Nginx
* PHP
* MySQL
* Rabbit
* MailHog
* Elasticsearch
* Varnish
* Selenium
* PostgreSQL
* Sandbox Mode _(for developer modules on Magento 2)_

## Requirements

* Docker community edition
* docker-compose


## Installation

Run the following command in your root project folder:

```
  curl -L -o warp http://ct.summasolutions.net/warp-engine/warp && chmod 755 warp
```

## Getting started

After download the warp binary file, you should initialize your dockerized infraestrucutre running the following command:

```
 ./warp init	
```

## Useful warp commands

This repo comes with some useful bash command:

|  Command  |  Description  |
|  -------  |  -----------  |
| **warp --help** | Shows the warp tool help |
| **warp [command] --help** | Shows the specific command help. For instance: warp php --help |
| **warp info** | Shows the configured values and useful information for each services |
| **warp init** |  Initialize the warp framework the first time before to start the project |
| **warp start** | Starts the containers |
| **warp stop** | Stops the containers |
| **warp reset** | Reset config to default |
| **warp fix** | fix common problems with permissions |


## Licensing

**warp engine framework** is licensed under the Apache License, Version 2.0.
See [LICENSE](LICENSE) for the full license text.



## Changelog

### See what has changed: [changes](CHANGES.md)

## Author Information

This project was started by [Matias Anoniz](https://github.com/yosoyfunes/) and [Sebastian Arrubia](https://github.com/sarrubia/)

![Matias Anoniz](https://github.com/yosoyfunes.png?size=100)
![Sebastian Arrubia](https://github.com/sarrubia.png?size=100)



