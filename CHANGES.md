Warp Releases
=============

### [2020.05.14](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.05.14)

* Add new image PHP 7.4-fpm
* Add image elasticsearch 7.6.2
* Add module APCU to PHP FPM 7.2, 7.3, 7.4
* Update node v12
* Change redis 5.0 by default

### [2020.04.28](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.04.28)

* Add new image elasticsearch 6.5.4
* Add deploy with Jenkins

### [2020.04.02](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.04.02)

* Add command warp magento --config-smile
* Add command warp magento --config-varnish
* Add command warp magento --developer-mode
* Add custom options to command warp magento --install-only <options>
* Improve warp fix --composer
* Improve startup script
* Validate frameword on mode Gandalf
* Clearing .gitignore after warp reset --hard
* Add users 500, 1000, 1001, 1002 to images PHP FPM 7.0, 7.1, 7.2, 7.3

### [2020.03.20](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.03.20)

* Add imagick to PHP 7.2-fpm, 7.3-fpm
* Add command warp fix --fast
* Add command warp magento --install-only
* Add command warp magento --install-redis
* Add alias=mage2smile to config smile on bash
* Fix image appdata
* Solve problem with .gitignore in Magento 2.3.x 

### [2020.03.12](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.03.12)

* Add Mode Galdalf to command init
* Check spaces at folders
* Check rsync version
* Add documentation https://summasolutions.github.io/warp-engine/

### [2020.03.09](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.03.09)

* Create warp-engine.github.io
* Improve command warp reset --hard
* Create volume for mysql custom
* Disable docker-sync by default
* Message docker-sync after warp init
* Fix docker-sync oro
* Add rsync command for Linux and MacOS
* New image summasolutions/appdata on registry docker

### [2020.02.29](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.02.29)

* Allow alphanumeric characters on project and client name
* Add feature to build images
* Add feature self update
* Add module pdo_pgsql and ldap on PHP 7.2-fpm
* Add module pdo_pgsql and ldap on PHP 7.3-fpm
* Add templates docker-sync-osx on projects Oro
* Change permissions chmod 400 before copying --credential
* Configure IP for xdebug cli on osx and linux
* Add custom Image with Postgres and UUID Support
* Set default php 7.2-fpm

### [2020.02.03](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.02.03)

* fix permission ES mode sandbox
* Add ES 6.4.2 mode sandbox
* Add no-interaction mode
* Add option to force update without confirmation

### [2020.01.20](https://github.com/SummaSolutions/warp-engine/releases/tag/2020.01.20)

* Add PHP 7.3-fpm
* Add dashboad web for supervisor
* Add templates for supervisor 

### [2019.11.21](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.11.21)

* add Mode Sandbox
* improve command fix for macOS
* add option for set memory on elasticsearch
* add cache composer from host
* increment timeout in docker-compose
* add images magento2-community 2.3.1, 2.2.9
* fix sodium in image php 7.2-fpm

### [2019.10.07](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.10.07)

* add PostgreSQL service 
* update image PHP to 7.1.32
* disable ionCube by default

### [2019.09.17](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.09.17)

* fix command init
* fix webserver varnish
* add template webserver multisite

### [2019.09.10](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.09.10)

* fix Varnish image
* set startup command to background
* add command to update images (warp update --images)

### [2019.08.30](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.08.30)

* add Varnish service v4.0.5, v5.2.1
* add Selenium service
* add postgres module on image PHP 7.1.17-fpm, 7.1.26-fpm
* add ionCube to PHP 7.0-fpm, 5.6-fpm
* add plugin delete-by-query on image elasticsearch 2.4
* add plugin x-delayer on image Rabbit
* allows to synchronize several files in warp sync command
* add command for Oro Framework (warp oro <command>)
* add command for check update images
* add command warp docker

### [2019.07.04](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.07.04)

* add sodium module php
* add mysql-client
* add gulp binary

### [2019.06.25](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.06.25)

* add command warp fix --composer
* workaround error session handler
* compatibility with previous version

### [2019.06.10](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.06.10)

* Fix install Magento
* Fix redis.so
* Fix warp_check_docker_version

### [2019.06.06](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.06.06)

* Add extension redis on php image

### [2019.05.30](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.05.30)

* Add command for enable/disable ionCube
* Add attach custom yaml file
* Improve command magento --install
* Check minimum version for Docker and docker-compose

### [2019.05.27](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.05.27)

* Add Image Elasticsearch 1.7.6
* Add Image Rabbitmq 3.7 with delayed queue plugin
* Add command for enable/disable xdebug
* Add command for download/install Magento Community
* Improve MacOS to be able to map files or synchronize folders

### [2019.05.08](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.05.08)

* Add Mailhog SMTP Server
* Exclude binaries folder .warp in repository
* Improve command fix permissions
* Change xdebug v2.6.1 for compatibility with PhpStorm


### [2019.04.08](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.04.08)

* Add command to fix permissions
* Add PHP 7.2-fpm
* Fix permission problem with Grunt command
* Improve alias mage2flush compatible with magento 2.3


### [2019.03.27](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.03.27)


* Adding private docker registry configuration
* Enabling supervisord in PHP 7.1.26-fpm
* Letting set the project base framework
* Set Nginx configuration based on set framework
* Allowing set a custom key-pair into PHP container to use it with composer


### [2019.02.20](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.02.20)

* set permissions with elasticsearch


### [2019.02.13](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.02.13)

* added RabitMQ service
* added PHP 7.1.26-fpm

### [2019.01.10](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.01.10)

* fix command install


### [2019.01.07](https://github.com/SummaSolutions/warp-engine/releases/tag/2019.01.07)

* adding alias for clear magento cache
* adding file for runlevel
* added additional parameter in xdebug


### [2018.12.20](https://github.com/SummaSolutions/warp-engine/releases/tag/2018.12.20)

* adding flag --ip in info command.
* bind bashrc in containers


### [2018.12.12](https://github.com/SummaSolutions/warp-engine/releases/tag/2018.12.12)

* adding video demo on landing page.
* fix permissions in html folder.
* Add control for the ed command.
* Improve FAQs about xdebug.


### [2018.11.20](https://github.com/SummaSolutions/warp-engine/releases/tag/2018.11.20)

* checking files before starting containers.


### [2018.11.16](https://github.com/SummaSolutions/warp-engine/releases/tag/2018.11.16)

* fix crontab process
* added command to edit crontab directly inside the container


### [2018.11.15](https://github.com/SummaSolutions/warp-engine/releases/tag/2018.11.15)

* First release