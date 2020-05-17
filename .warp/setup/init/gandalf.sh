#!/bin/bash +x

# INIT PROJECTS MODE GANDALF WITHOUT WIZARD

for i in "$@"
do
    case $i in
        --namespace=*)
        GF_NAMESPACE="${i#*=}"
        shift # past argument=value
        ;;
        --project=*)
        GF_PROJECT="${i#*=}"
        shift # past argument=value
        ;;
        --private-registry=*)
        GF_PRIVATE_REGISTRY="${i#*=}"
        shift # past argument=value
        ;;
        --framework=*)
        GF_FRAMEWORK="${i#*=}"
        shift # past argument=value
        ;;
        --vhost=*)
        GF_NGINX_VHOST="${i#*=}"
        shift # past argument=value
        ;;
        --php=*)
        GF_PHP_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --mysql=*)
        GF_MYSQL_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --postgres=*)
        GF_POSTGRES_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --es=*|--elasticsearch=*)
        GF_ELASTICSEARCH_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --redis=*)
        GF_REDIS_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --redis-fpc=*)
        GF_REDIS_FPC_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --redis-session=*)
        GF_REDIS_SESSION_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --redis-cache=*)
        GF_REDIS_CACHE_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --rabbit=*)
        GF_RABBIT_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        --mailhog=*|--mailhog)
        GF_MAILHOG="Y"
        shift # past argument=value
        ;;
        --varnish=*|--varnish)
        GF_VARNISH_VERSION="${i#*=}"
        shift # past argument=value
        ;;
        *)
        # unknown option
        ;;
    esac;
done;

### Validations
. "$WARPFOLDER/setup/init/gandalf-validations.sh"

############### SERVICES & BASE
. "$WARPFOLDER/setup/init/service.sh"

namespace_name=$GF_NAMESPACE
project_name=$GF_PROJECT
docker_private_registry=$GF_PRIVATE_REGISTRY
framework=$GF_FRAMEWORK

echo "# Project configurations" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "NAMESPACE=${namespace_name}" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "PROJECT=${project_name}" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "DOCKER_PRIVATE_REGISTRY=${docker_private_registry}" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "FRAMEWORK=${framework}" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

echo "# Docker configurations" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "COMPOSE_HTTP_TIMEOUT=$DOCKER_COMPOSE_HTTP_TIMEOUT" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

echo "# VERSION Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "WARP_VERSION=$WARP_VERSION" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

### MACOS
# Generate sample files
cat $PROJECTPATH/.warp/setup/mac/tpl/docker-compose-warp-mac.yml > $DOCKERCOMPOSEFILEMACSAMPLE
cat $PROJECTPATH/.warp/setup/mac/tpl/docker-sync.yml > $DOCKERSYNCMACSAMPLE

if [[ "$framework" = "oro" ]]
then
    cat $PROJECTPATH/.warp/setup/mac/tpl/docker-mapping-oro-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
else
    cat $PROJECTPATH/.warp/setup/mac/tpl/docker-mapping-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
fi

VOLUME_WARP_DEFAULT="warp-volume-sync"
VOLUME_WARP="$(basename $(pwd))-volume-sync"

cat $DOCKERCOMPOSEFILEMAC | sed -e "s/$VOLUME_WARP_DEFAULT/$VOLUME_WARP/" > "$DOCKERCOMPOSEFILEMAC.tmp"
mv "$DOCKERCOMPOSEFILEMAC.tmp" $DOCKERCOMPOSEFILEMAC

cp $DOCKERSYNCMACSAMPLE $DOCKERSYNCMAC

echo "# Docker Sync" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "USE_DOCKER_SYNC=N" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

############### WEBSERVER
if [[ ! -z $GF_NGINX_VHOST ]]
then
    warp_message_info "Configuring Web Server - Nginx"

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# NGINX Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE

    cat $PROJECTPATH/.warp/setup/webserver/tpl/webserver.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "HTTP_BINDED_PORT=80" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "HTTPS_BINDED_PORT=443" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "HTTP_HOST_IP=0.0.0.0" >> $ENVIRONMENTVARIABLESFILESAMPLE

    echo "VIRTUAL_HOST=$GF_NGINX_VHOST" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "NGINX_CONFIG_FILE=./.warp/docker/config/nginx/sites-enabled/$GF_NGINX_VHOST.conf" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    mkdir -p $PROJECTPATH/.warp/docker/volumes/nginx/logs
    chmod -R 777 $PROJECTPATH/.warp/docker/volumes/nginx

    cp -R $PROJECTPATH/.warp/setup/webserver/config/nginx $CONFIGFOLDER/nginx

    # prepare files for Varnish service
    if [ ! -d $CONFIGFOLDER/varnish ]
    then
        cp -R $PROJECTPATH/.warp/setup/varnish/config/varnish $CONFIGFOLDER/varnish
    fi;

    # Copying proxy configuration
    cat $PROJECTPATH/.warp/setup/webserver/config/nginx/sites-enabled/proxy.conf | sed -e "s/{{SERVER_NAME}}/${GF_NGINX_VHOST}/" > $CONFIGFOLDER/nginx/sites-enabled/proxy.conf

    # Copying nginx base framework configuration
    case $framework in
        'm1')
            cat $CONFIGFOLDER/nginx/sites-enabled/m1.conf | sed -e "s/{{SERVER_NAME}}/${GF_NGINX_VHOST}/" > $CONFIGFOLDER/nginx/sites-enabled/${GF_NGINX_VHOST}.conf
        ;;
        'm2')
            cat $CONFIGFOLDER/nginx/sites-enabled/m2.conf | sed -e "s/{{SERVER_NAME}}/${GF_NGINX_VHOST}/" > $CONFIGFOLDER/nginx/sites-enabled/${GF_NGINX_VHOST}.conf
        ;;
        'oro')
            cat $CONFIGFOLDER/nginx/sites-enabled/oro.conf | sed -e "s/{{SERVER_NAME}}/${GF_NGINX_VHOST}/" > $CONFIGFOLDER/nginx/sites-enabled/${GF_NGINX_VHOST}.conf
        ;;
        'php')
            cat $CONFIGFOLDER/nginx/sites-enabled/php.conf | sed -e "s/{{SERVER_NAME}}/${GF_NGINX_VHOST}/" > $CONFIGFOLDER/nginx/sites-enabled/${GF_NGINX_VHOST}.conf
        ;;
        *)
            cat $CONFIGFOLDER/nginx/sites-enabled/php.conf | sed -e "s/{{SERVER_NAME}}/${GF_NGINX_VHOST}/" > $CONFIGFOLDER/nginx/sites-enabled/${GF_NGINX_VHOST}.conf
        ;;
    esac

fi

############### PHP
if [[ ! -z $GF_PHP_VERSION ]]
then
    warp_message_info "Configuring PHP Service"

    cat $PROJECTPATH/.warp/setup/php/tpl/php.yml >> $DOCKERCOMPOSEFILESAMPLE

    php_version=$GF_PHP_VERSION

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# Config PHP" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "PHP_VERSION=$php_version" >> $ENVIRONMENTVARIABLESFILESAMPLE

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# Config xdebug by Console"  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "XDEBUG_CONFIG=remote_host=172.17.0.1" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "PHP_IDE_CONFIG=serverName=docker" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE

    mkdir -p $PROJECTPATH/.warp/docker/volumes/php-fpm/logs 2> /dev/null
    # Create logs file
    [ ! -f $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/access.log ] && touch $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/access.log  2> /dev/null
    [ ! -f $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-error.log ] && touch $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-error.log 2> /dev/null
    [ ! -f $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-php.www.log ] && touch $PROJECTPATH/.warp/docker/volumes/php-fpm/logs/fpm-php.www.log 2> /dev/null
        
    mkdir -p $PROJECTPATH/.warp/docker/volumes/supervisor/logs 2> /dev/null
    [ ! -f $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log ] && touch $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log 2> /dev/null
    chmod 777 $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log 2> /dev/null

    cp -R $PROJECTPATH/.warp/setup/php/config/php $PROJECTPATH/.warp/docker/config/php
    cp -R $PROJECTPATH/.warp/setup/php/config/crontab $PROJECTPATH/.warp/docker/config/crontab
    cp -R $PROJECTPATH/.warp/setup/php/config/supervisor $PROJECTPATH/.warp/docker/config/supervisor

    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 

    echo "## CONFIG XDEBUG FOR $php_version ##" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
    echo "## CONFIG IONCUBE FOR $php_version ##" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
    
     case $php_version in
        '5.6-fpm')
            echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
            echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20131226/iocube.so" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
        ;;
        '7.0-fpm')
            echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
            echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/iocube.so" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
        ;;
        '7.2-fpm')
            echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
            echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/iocube.so" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
        ;;
        '7.3-fpm')
            echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20180731/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
            echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20180731/iocube.so" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
        ;;
        '7.4-fpm')
            echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
            echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20190902/iocube.so" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
        ;;
        *)
            echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
            echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/iocube.so" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
        ;;
    esac

    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample
    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample
fi

############### VOLUMES
. "$WARPFOLDER/setup/init/volumes.sh"

############### MYSQL
if [[ ! -z $GF_MYSQL_VERSION ]]
then
    warp_message_info "Configuring MySQL Service"

    mysql_version=$GF_MYSQL_VERSION
    mysql_docker_image="mysql:${mysql_version}"
    mysql_binded_port="3306"
    mysql_name_database="warp_db"  
    mysql_user_database="warp"
    mysql_password_database="Warp2020"

    if [ ! -z "$docker_private_registry" ]
    then
        # Overwrite default mysql image.
        mysql_docker_image="${namespace_name}-${project_name}-dbs"    
        mysql_use_project_specific=Y
    fi  

    # Default Random password for user root
    default_mysql_root_password=$(warp_env_random_password $STRONG_PASSWORD_LENGTH)
    mysql_root_password=${default_mysql_root_password}    
    mysql_config_file="./.warp/docker/config/mysql/conf.d"    

    if [ "$mysql_use_project_specific" = "Y" ] || [ "$mysql_use_project_specific" = "y" ]; then
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database_custom.yml >> $DOCKERCOMPOSEFILESAMPLE
    else
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database.yml >> $DOCKERCOMPOSEFILESAMPLE
    fi
    
    cat $PROJECTPATH/.warp/setup/mysql/tpl/database_enviroment_root.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "# MySQL Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_VERSION=$mysql_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_DOCKER_IMAGE=$mysql_docker_image" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_CONFIG_FILE=$mysql_config_file" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_BINDED_PORT=$mysql_binded_port" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_ROOT_PASSWORD=$mysql_root_password" >> $ENVIRONMENTVARIABLESFILESAMPLE

    cat $PROJECTPATH/.warp/setup/mysql/tpl/database_enviroment_default.yml >> $DOCKERCOMPOSEFILESAMPLE
    echo "DATABASE_NAME=$mysql_name_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_USER=$mysql_user_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_PASSWORD=$mysql_password_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE

    if [ "$mysql_use_project_specific" = "Y" ] || [ "$mysql_use_project_specific" = "y" ]; then
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database_volumes_networks_custom.yml >> $DOCKERCOMPOSEFILESAMPLE
    else
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database_volumes_networks.yml >> $DOCKERCOMPOSEFILESAMPLE
    fi    

    cp -R $PROJECTPATH/.warp/setup/mysql/config/ $PROJECTPATH/.warp/docker/config/mysql/
fi

############### POSTGRES
if [[ ! -z $GF_POSTGRES_VERSION ]]
then
    warp_message_info "Configuring PostgreSQL Service"
    cat $PROJECTPATH/.warp/setup/postgres/tpl/postgres.yml >> $DOCKERCOMPOSEFILESAMPLE

    psql_version=$GF_POSTGRES_VERSION
    psql_binded_port="5432"
    psql_name_database="warp_db"
    psql_user_database="warp"
    psql_password_database="Warp2020"

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# PostgreSQL Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_VERSION=$psql_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_BINDED_PORT=$psql_binded_port" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_DB=$psql_name_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_USER=$psql_user_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_PASSWORD=$psql_password_database" >> $ENVIRONMENTVARIABLESFILESAMPLE    
fi

############### ELASTICSEARCH
if [[ ! -z $GF_ELASTICSEARCH_VERSION ]]
then
    warp_message_info "Configuring ElasticSearch Service"
    elasticsearch_version=$GF_ELASTICSEARCH_VERSION
    elasticsearch_memory="512m"

    cat $PROJECTPATH/.warp/setup/elasticsearch/tpl/elasticsearch.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# Elasticsearch" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "ES_VERSION=$elasticsearch_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "ES_MEMORY=$elasticsearch_memory" >> $ENVIRONMENTVARIABLESFILESAMPLE
fi

############### REDIS
if [[ ! -z $GF_REDIS_VERSION ]] || [[ ! -z $GF_REDIS_CACHE_VERSION ]] || [[ ! -z $GF_REDIS_FPC_VERSION ]] || [[ ! -z $GF_REDIS_SESSION_VERSION ]]
then
    warp_message_info "Configuring Redis Service"

    resp_version_cache=$GF_REDIS_VERSION
    cache_config_file_cache="./.warp/docker/config/redis/redis.conf"

    resp_version_session=$GF_REDIS_VERSION
    cache_config_file_session="./.warp/docker/config/redis/redis.conf"

    resp_version_fpc=$GF_REDIS_VERSION
    cache_config_file_fpc="./.warp/docker/config/redis/redis.conf"

    PATH_CONFIG_REDIS='./.warp/docker/config/redis'

    echo "#Config Redis" >> $ENVIRONMENTVARIABLESFILESAMPLE

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_cache.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_CACHE_VERSION=$resp_version_cache" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_CACHE_CONF=$cache_config_file_cache" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_session.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_SESSION_VERSION=$resp_version_session" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_SESSION_CONF=$cache_config_file_session" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_fpc.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_FPC_VERSION=$resp_version_fpc" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_FPC_CONF=$cache_config_file_fpc" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    # Control will enter here if $PATH_CONFIG_REDIS doesn't exist.
    if [ ! -d "$PATH_CONFIG_REDIS" ]; then
        cp -R ./.warp/setup/redis/config/redis $PATH_CONFIG_REDIS
    fi
    warp_message ""
fi

############### RABBIT
if [[ ! -z $GF_RABBIT_VERSION ]]
then
    warp_message_info "Configuring Rabbit Service"
    cat $PROJECTPATH/.warp/setup/rabbit/tpl/rabbit.yml >> $DOCKERCOMPOSEFILESAMPLE

    resp_version_rabbit=$GF_RABBIT_VERSION
    rabbit_binded_port="8081"
    rabbit_default_user="guest"
    rabbit_default_password="guest"

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "#Config Rabbit" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBIT_VERSION=$resp_version_rabbit" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBIT_BINDED_PORT=$rabbit_binded_port"  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBITMQ_DEFAULT_USER=$rabbit_default_user" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBITMQ_DEFAULT_PASS=$rabbit_default_password"  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
fi

############### MAILHOG
if [[ ! -z $GF_MAILHOG ]]
then
    warp_message_info "Configuring Mailhog SMTP server"
    cat $PROJECTPATH/.warp/setup/mailhog/tpl/mailhog.yml >> $DOCKERCOMPOSEFILESAMPLE

    mailhog_binded_port="8025"

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "#Config Mailhog" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MAILHOG_BINDED_PORT=$mailhog_binded_port"  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
fi

############### VARNISH
if [[ ! -z $GF_VARNISH_VERSION ]]
then
    warp_message_info "Configuring Varnish Service"

    if [ ! -d $CONFIGFOLDER/varnish ]
    then
        cp -R $PROJECTPATH/.warp/setup/varnish/config/varnish $CONFIGFOLDER/varnish
    fi;

    cat $PROJECTPATH/.warp/setup/varnish/tpl/varnish.yml >> $DOCKERCOMPOSEFILESAMPLE

    respuesta_varnish=Y
    varnish_version=$GF_VARNISH_VERSION

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# VARNISH Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "USE_VARNISH=$respuesta_varnish" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "VARNISH_VERSION=$varnish_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
fi

# Adittional config 
. "$WARPFOLDER/setup/volumes/volumes.sh"
. "$WARPFOLDER/setup/networks/networks.sh"
. "$WARPFOLDER/setup/init/info.sh"