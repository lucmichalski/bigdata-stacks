#!/bin/bash +x

warp_message ""
warp_message_info "Configuring SANDBOX M2"
warp_message ""

    warp_message_warn "sandbox mode automatically configures the following services"

    warp_message ""
    warp_message_info "* PHP"
    warp_message "Version:                    $(warp_message_info '7.0-fpm, 7.1-fpm, 7.2-fpm')"
    warp_message ""

    warp_message_info "* MySQL"
    warp_message "Version:                    $(warp_message_info 5.7)"
    warp_message "Database:                   $(warp_message_info $DB_M22_CE)"
    warp_message "Database:                   $(warp_message_info $DB_M23_CE)"
    warp_message ""

    warp_message_info "* Webserver"
    warp_message "Version 2.2.9 CE:           $(warp_message_info $VHOST_M22_CE)"
    warp_message "Version 2.3.1 EE:           $(warp_message_info $VHOST_M23_CE)"
    warp_message ""

    warp_message_info "* Redis"
    warp_message "Type:                       $(warp_message_info 'CACHE, SESSION, FPC')"
    warp_message ""

    warp_message_info "* Elasticsearch"
    warp_message "Version:                    $(warp_message_info '5.6.8, 6.4.2')"
    warp_message ""

######## MODE SANDBOX ########
while : ; do    
    respuesta_sandbox=$( warp_question_ask_default "Do you want to continue? $(warp_message_info [y/N]) " "N" )

    if [ "$respuesta_sandbox" = "Y" ] || [ "$respuesta_sandbox" = "y" ] || [ "$respuesta_sandbox" = "N" ] || [ "$respuesta_sandbox" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_sandbox" = "Y" ] || [ "$respuesta_sandbox" = "y" ]
then
    echo "# SANDBOX Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MODE_SANDBOX=$respuesta_sandbox" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "COMPOSE_HTTP_TIMEOUT=$DOCKER_COMPOSE_HTTP_TIMEOUT" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

else
    warp_message_warn "Abort Installation"
    exit 1;
fi;

######## VENDOR MODULE
echo ""
warp_message_info "Configuring Vendor & Module name"
warp_message_warn "if you want to work on app/code leave blank: Vendor Name"

work_on_app_code=1

while : ; do    
    vendor_name=$( warp_question_ask "Vendor name: ")
    
    if [ -z "$vendor_name" ]
    then
        ask_module_ok=$( warp_question_ask_default "do you want to work on app/code/? $(warp_message_info [Y/n]) " "Y" )
        work_on_app_code=1
    else
        module_name=$( warp_question_ask "Module name: ")
        if [ -z "$module_name" ]
        then
            warp_message_warn "if you want to set Vendor Name, you must set Module Name"
        else
            ask_module_ok=$( warp_question_ask_default "do you want to set: app/code/$vendor_name/$module_name? $(warp_message_info [Y/n]) " "Y" )
            work_on_app_code=0
        fi
    fi

    if [ "$ask_module_ok" = "Y" ] || [ "$ask_module_ok" = "y" ] ; then
        break
    fi
done

if [ $work_on_app_code = 1 ] ; then
    warp_message_info2 "Set app/code/ as main folder"
else
    warp_message_info2 "Set app/code/$vendor_name/$module_name"
fi

echo "# Module configurations" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "VENDOR_NAME=${vendor_name}" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "MODULE_NAME=${module_name}" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

######## SERVICE

. "$WARPFOLDER/setup/init/service.sh"

######## WEBSERVER
echo ""
warp_message_info "Configuring Webserver"

    while : ; do
        http_port=$( warp_question_ask_default "Mapping container port 80 to your machine port (host): $(warp_message_info [80]) " "80" )

        #CHECK si port es numero antes de llamar a warp_net_port_in_use
        if ! warp_net_port_in_use $http_port ; then
            warp_message_info2 "The selected port is: $http_port"
            break
        else
            warp_message_warn "the port $http_port is busy, choose another one\n"
        fi;
    done

    while : ; do
        https_port=$( warp_question_ask_default "Mapping container port 443 to your machine port (host): $(warp_message_info [443]) " "443" )

        if ! warp_net_port_in_use $https_port ; then
            warp_message_info2 "The selected port is: $https_port"
            break
        else
            warp_message_warn "the port $https_port is busy, choose another one\n"
        fi;
    done
    
    echo "# NGINX Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE

    cat $PROJECTPATH/.warp/setup/sandbox/tpl/webserver.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "HTTP_BINDED_PORT=$http_port" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "HTTPS_BINDED_PORT=$https_port" >> $ENVIRONMENTVARIABLESFILESAMPLE

    echo "VIRTUAL_HOST_M22_CE=$VHOST_M22_CE" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "VIRTUAL_HOST_M23_CE=$VHOST_M23_CE" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "NGINX_CONFIG_FILE=./.warp/docker/config/nginx/sites-enabled/sandbox-m2.conf" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    mkdir -p $PROJECTPATH/.warp/docker/volumes/nginx/logs
    chmod -R 777 $PROJECTPATH/.warp/docker/volumes/nginx

    cp -R $PROJECTPATH/.warp/setup/webserver/config/nginx $CONFIGFOLDER/nginx

######## PHP
echo ""
warp_message_info "Configuring PHP Service $(warp_message_ok [ok])"

    cat $PROJECTPATH/.warp/setup/sandbox/tpl/php-m2.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "# Config PHP" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "PHP_70=7.0-fpm" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "PHP_71=7.1-fpm" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "PHP_72=7.2-fpm" >> $ENVIRONMENTVARIABLESFILESAMPLE
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
    # chmod -R 775 $PROJECTPATH/.warp/docker/volumes/php-fpm 2> /dev/null
        
    mkdir -p $PROJECTPATH/.warp/docker/volumes/supervisor/logs 2> /dev/null
    [ ! -f $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log ] && touch $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log 2> /dev/null
    chmod 777 $PROJECTPATH/.warp/docker/volumes/supervisor/logs/supervisord.log 2> /dev/null

    cp -R $PROJECTPATH/.warp/setup/php/config/php $PROJECTPATH/.warp/docker/config/php
    cp -R $PROJECTPATH/.warp/setup/php/config/php $PROJECTPATH/.warp/docker/config/php71
    cp -R $PROJECTPATH/.warp/setup/php/config/php $PROJECTPATH/.warp/docker/config/php72

    cp -R $PROJECTPATH/.warp/setup/php/config/crontab $PROJECTPATH/.warp/docker/config/crontab
    cp -R $PROJECTPATH/.warp/setup/php/config/supervisor $PROJECTPATH/.warp/docker/config/supervisor

    ###---------70
    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 

    echo "## CONFIG XDEBUG FOR 7.0-fpm ##" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
    echo "## CONFIG IONCUBE FOR 7.0-fpm ##" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample 

    echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample 
    echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/iocube.so" >> $PROJECTPATH/.warp/docker/config/php/ext-iocube.ini.sample 

    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample
    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample

    ###---------71
    echo "" >> $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini.sample 

    echo "## CONFIG XDEBUG FOR 7.1-fpm ##" >> $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini.sample 
    echo "## CONFIG IONCUBE FOR 7.1-fpm ##" >> $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini.sample 

    echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini.sample 
    echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/iocube.so" >> $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini.sample 

    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini.sample
    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini.sample

    ###---------72
    echo "" >> $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini.sample 
    echo "" >> $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini.sample

    echo "## CONFIG XDEBUG FOR 7.2-fpm ##" >> $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini.sample 
    echo "## CONFIG IONCUBE FOR 7.2-fpm ##" >> $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini.sample 

    echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so" >> $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini.sample 
    echo ";zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/iocube.so" >> $PROJECTPATH/.warp/docker/config/php72/ext-iocube.ini.sample 

    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini.sample
    echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini.sample
    ###---------

######## APPDATA
warp_message_info "Configuring mapping files $(warp_message_ok [ok])"

    cp -R $PROJECTPATH/.warp/setup/init/config/appdata $PROJECTPATH/.warp/docker/config/appdata
    cp -R $PROJECTPATH/.warp/setup/init/config/bash $PROJECTPATH/.warp/docker/config/bash
    cp -R $PROJECTPATH/.warp/setup/init/config/etc $PROJECTPATH/.warp/docker/config/etc

    # Generate sample files
    if [ $work_on_app_code = 1 ] ; then
        cat $PROJECTPATH/.warp/setup/sandbox/tpl/docker-mapping-app-code.yml > $DOCKERCOMPOSEFILEDEVSAMPLE
    else
        cat $PROJECTPATH/.warp/setup/sandbox/tpl/docker-mapping-warp-dev.yml > $DOCKERCOMPOSEFILEDEVSAMPLE
    fi

    cat $PROJECTPATH/.warp/setup/sandbox/tpl/appdata.yml >> $DOCKERCOMPOSEFILESAMPLE

    VOLUME_WARP_DEFAULT="warp-volume-sync"
    VOLUME_WARP="$(basename $(pwd))-volume-sync"

    cat $DOCKERCOMPOSEFILEDEVSAMPLE | sed -e "s/$VOLUME_WARP_DEFAULT/$VOLUME_WARP/" > "$DOCKERCOMPOSEFILEDEV.tmp"
    mv "$DOCKERCOMPOSEFILEDEV.tmp" $DOCKERCOMPOSEFILEDEV

######## MYSQL
warp_message ""
warp_message_info "Configuring the MySQL Service"

    mysql_version="5.7"
    warp_message_info2 "MySQL version: $mysql_version"

    warp_message_info2 "Setting the database: $DB_M22_CE"
    warp_message_info2 "Setting the database: $DB_M23_CE"

    while : ; do
        mysql_binded_port=$( warp_question_ask_default "Mapping container port 3306 to your machine port (host): $(warp_message_info [3306]) " "3306" )

        #CHECK si port es numero antes de llamar a warp_net_port_in_use
        if ! warp_net_port_in_use $mysql_binded_port ; then
            warp_message_info2 "the selected port is: $mysql_binded_port, the port mapping is: $(warp_message_bold '127.0.0.1:'$mysql_binded_port' ---> container_host:3306')"
            break
        else
            warp_message_warn "The port $mysql_binded_port is busy, choose another one\n"
        fi;
    done

    # Default Random password for user root
    default_mysql_root_password=$(warp_env_random_password $STRONG_PASSWORD_LENGTH)

    mysql_root_password=$( warp_question_ask_default "Set the MySQL main password (root user)? $(warp_message_info [$default_mysql_root_password]) " "$default_mysql_root_password" )
    warp_message_info2 "Root user password: $mysql_root_password"
    mysql_config_file=$( warp_question_ask_default "Add the MySQL configuration file: $(warp_message_info [./.warp/docker/config/mysql/conf.d]) " "./.warp/docker/config/mysql/conf.d" )
    warp_message_info2 "Selected configuration file: $mysql_config_file"

    cat $PROJECTPATH/.warp/setup/sandbox/tpl/mysql.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "# MySQL Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_VERSION=$mysql_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_CONFIG_FILE=$mysql_config_file" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_BINDED_PORT=$mysql_binded_port" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_ROOT_PASSWORD=$mysql_root_password" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
    
    cp -R $PROJECTPATH/.warp/setup/mysql/config/ $PROJECTPATH/.warp/docker/config/mysql/

######## REDIS
warp_message ""
warp_message_info "Configuring the Redis Service"

    PATH_CONFIG_REDIS='./.warp/docker/config/redis'

    echo "#Config Redis" >> $ENVIRONMENTVARIABLESFILESAMPLE

    resp_version=$( warp_question_ask_default "What version of Redis do you want to use? $(warp_message_info [3.2.10-alpine]) " "3.2.10-alpine" )
    warp_message_info2 "Selected Redis Cache version: $resp_version, in the internal port 6379 $(warp_message_bold 'redis-cache:6379')"

    cache_config_file_redis=$( warp_question_ask_default "Set Redis configuration file: $(warp_message_info [./.warp/docker/config/redis/redis.conf]) " "./.warp/docker/config/redis/redis.conf" )
    warp_message_info2 "Selected configuration file: $cache_config_file_redis"

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_cache.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_CACHE_VERSION=$resp_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_CACHE_CONF=$cache_config_file_redis" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    warp_message ""

    warp_message_info2 "Set Redis Session: $resp_version, in the internal port 6379 $(warp_message_bold 'redis-session:6379')"

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_session.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_SESSION_VERSION=$resp_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_SESSION_CONF=$cache_config_file_redis" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    warp_message ""

    warp_message_info2 "Set Redis FPC version: $resp_version, in the internal port 6379 $(warp_message_bold 'redis-fpc:6379')"

    cat $PROJECTPATH/.warp/setup/redis/tpl/redis_fpc.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "REDIS_FPC_VERSION=$resp_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "REDIS_FPC_CONF=$cache_config_file_redis" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    # Control will enter here if $PATH_CONFIG_REDIS doesn't exist.
    if [ ! -d "$PATH_CONFIG_REDIS" ]; then
        cp -R ./.warp/setup/redis/config/redis $PATH_CONFIG_REDIS
    fi
    warp_message ""

######## ELASTICSEARCH
warp_message "* Configuring ElasticSearch Service $(warp_message_ok [ok])"

cat $PROJECTPATH/.warp/setup/sandbox/tpl/elasticsearch.yml >> $DOCKERCOMPOSEFILESAMPLE

echo "# Elasticsearch" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "ES_VERSION56=$ES_SB1" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "ES_VERSION64=$ES_SB2" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "ES_MEMORY=$ES_SBMEM" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE

mkdir -p   $PROJECTPATH/.warp/docker/volumes/elasticsearch56
mkdir -p   $PROJECTPATH/.warp/docker/volumes/elasticsearch64

######## NETWORK
warp_message "* Configuring Network $(warp_message_ok [ok])"

cat $PROJECTPATH/.warp/setup/sandbox/tpl/network.yml >> $DOCKERCOMPOSEFILESAMPLE

######## MAGENTO FILES
warp_message "* Generate Magento templates $(warp_message_ok [ok])"

if [ ! -d $PROJECTPATH/.platform ]
then
    mkdir -p $PROJECTPATH/.platform
    cp -R $PROJECTPATH/.warp/setup/sandbox/magentos/* $PROJECTPATH/.platform
fi

########

[ ! -f $DOCKERCOMPOSEFILEDEV ] && cp $DOCKERCOMPOSEFILEDEVSAMPLE $DOCKERCOMPOSEFILEDEV

. "$WARPFOLDER/setup/init/info.sh"

# creating ext-ioncube.ini
if  [ ! -f $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini ] && [ -f $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini.sample ]
then
    cp $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini.sample $PROJECTPATH/.warp/docker/config/php71/ext-ioncube.ini
fi

# creating ext-ioncube.ini
if  [ ! -f $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini ] && [ -f $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini.sample ]
then
    cp $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini.sample $PROJECTPATH/.warp/docker/config/php72/ext-ioncube.ini
fi

# creating ext-xdebug.ini
if  [ ! -f $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini ] && [ -f $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini.sample ]
then
    cp $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini.sample $PROJECTPATH/.warp/docker/config/php71/ext-xdebug.ini
fi

# creating ext-xdebug.ini
if  [ ! -f $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini ] && [ -f $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini.sample ]
then
    cp $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini.sample $PROJECTPATH/.warp/docker/config/php72/ext-xdebug.ini
fi
