#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/magento_help.sh"

function magento_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        magento_help_usage 
        exit 0;
    fi;

    if [ "$1" = "--download" ]
    then
        shift 1
        magento_download $*
        exit 0;
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 0;
    fi

    if [ "$1" = "--install-only" ]
    then
        magento_install_only $*
        exit 0;
    fi;

    if [ "$1" = "--config-redis" ]
    then
        magento_config_redis
        exit 0;
    fi;

    if [ "$1" = "--config-varnish" ]
    then
        magento_config_varnish
        exit 0;
    fi;

    if [ "$1" = "--config-smile" ]
    then
        magento_config_smile
        exit 0;
    fi;

    if [ "$1" = "--config-dev" ]
    then
        magento_config_developer_mode
        exit 0;
    fi;

    if [ "$1" = "--generate-data" ]
    then
        magento_generate_fixtures
        exit 0;
    fi;

    if [ "$1" = "--install" ]
    then
        magento_install
        exit 0;
    fi;

    FRAMEWORK=$(warp_env_read_var FRAMEWORK)
    if [ "$FRAMEWORK" = "m1" ]
    then
        MAGENTOBIN='./n98-magerun'
    else
        MAGENTOBIN='bin/magento'
    fi

    if [ "$1" = "--root" ]
    then
        shift 1
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "$MAGENTOBIN $*"
    elif [ "$1" = "-T" ] ; then
        shift 1
        docker-compose -f $DOCKERCOMPOSEFILE exec -T php bash -c "$MAGENTOBIN $*"
    else

        docker-compose -f $DOCKERCOMPOSEFILE exec php bash -c "$MAGENTOBIN $*"
    fi
}

function magento_install()
{
    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit 0;
    fi; 

    VIRTUAL_HOST=$(warp_env_read_var VIRTUAL_HOST)
    DATABASE_NAME=$(warp_env_read_var DATABASE_NAME)
    DATABASE_USER=$(warp_env_read_var DATABASE_USER)
    DATABASE_PASSWORD=$(warp_env_read_var DATABASE_PASSWORD)
    USE_DOCKER_SYNC=$(warp_env_read_var USE_DOCKER_SYNC)
    REDIS_CACHE_VERSION=$(warp_env_read_var REDIS_CACHE_VERSION)
    REDIS_FPC_VERSION=$(warp_env_read_var REDIS_FPC_VERSION)
    REDIS_SESSION_VERSION=$(warp_env_read_var REDIS_SESSION_VERSION)

    ADMIN_USER="admin"
    ADMIN_PASS="Password123"

    case "$(uname -s)" in
      Darwin)
        if [ "$USE_DOCKER_SYNC" = "N" ] || [ "$USE_DOCKER_SYNC" = "n" ] ; then 
            warp_message "Copying all files from host to container..."
            warp rsync push --all
            warp fix --fast
            sleep 2 #Ensure containers are started...
        fi        
      ;;
      Linux)
        # Permissions
        warp fix --owner
      ;;
    esac

    warp_message "Forcing reinstall of composer deps to ensure perms & reqs..."
    warp composer install --prefer-dist --ignore-platform-reqs

    warp magento setup:install \
        --backend-frontname=admin \
        --db-host=mysql \
        --db-name=$DATABASE_NAME \
        --db-user=$DATABASE_USER \
        --db-password=$DATABASE_PASSWORD \
        --base-url=https://$VIRTUAL_HOST/ \
        --admin-firstname=Admin \
        --admin-lastname=Admin \
        --admin-email=admin@admin.com \
        --admin-user=$ADMIN_USER \
        --admin-password=$ADMIN_PASS \
        --language=es_AR \
        --currency=ARS \
        --timezone=America/Argentina/Buenos_Aires \
        --use-rewrites=1

    warp_message "Turning on developer mode.."
    warp magento deploy:mode:set developer

    warp_message "Reindex all indexers"
    warp magento indexer:reindex

    warp_message "Forcing deploy of static content to speed up initial requests..."
    warp magento setup:static-content:deploy -f 

    if [ ! -z "$REDIS_CACHE_VERSION" ]
    then
        warp_message "Enabling redis for cache..."
        warp magento setup:config:set --no-interaction --cache-backend=redis --cache-backend-redis-server=redis-cache --cache-backend-redis-db=0
    fi

    if [ ! -z "$REDIS_FPC_VERSION" ]
    then
        warp_message "Enabling redis for full page cache..."
        warp magento setup:config:set --no-interaction --page-cache=redis --page-cache-redis-server=redis-fpc --page-cache-redis-db=1
    fi

    if [ ! -z "$REDIS_SESSION_VERSION" ]
    then
        warp_message "Enabling Redis for session..."
        warp magento setup:config:set --no-interaction --session-save=redis --session-save-redis-host=redis-session --session-save-redis-log-level=4 --session-save-redis-db=1
    fi

    warp_message "Clearing the cache for good measure..."
    warp magento cache:flush

    case "$(uname -s)" in
      Darwin)
        if [ "$USE_DOCKER_SYNC" = "N" ] || [ "$USE_DOCKER_SYNC" = "n" ] ; then 
            warp_message "Copying files from container to host after install..."
            warp rsync pull app
            warp rsync pull vendor
        fi
      ;;
    esac

    warp_message "Restarting containers with host bind mounts for dev..."
    warp restart

    warp_message "Docker development environment setup complete."
    warp_message "You may now access your Magento instance at https://${VIRTUAL_HOST}/"
    warp_message "Admin user: $ADMIN_USER"
    warp_message "Admin pass: $ADMIN_PASS"
}

function magento_install_only()
{
    VIRTUAL_HOST=$(warp_env_read_var VIRTUAL_HOST)
    DATABASE_NAME=$(warp_env_read_var DATABASE_NAME)
    DATABASE_USER=$(warp_env_read_var DATABASE_USER)
    DATABASE_PASSWORD=$(warp_env_read_var DATABASE_PASSWORD)
    USE_DOCKER_SYNC=$(warp_env_read_var USE_DOCKER_SYNC)
    REDIS_CACHE_VERSION=$(warp_env_read_var REDIS_CACHE_VERSION)
    REDIS_FPC_VERSION=$(warp_env_read_var REDIS_FPC_VERSION)
    REDIS_SESSION_VERSION=$(warp_env_read_var REDIS_SESSION_VERSION)

    ADMIN_USER="admin"
    ADMIN_PASS="Password123"

    warp_message "Install Magento.."

    # check extra-parameters
    if [ $# -eq 1 ] ; then
        EXTRA_PARAMS=""
    else 
        shift 1
        EXTRA_PARAMS=$*        
    fi;

    warp magento setup:install \
        --backend-frontname=admin \
        --db-host=mysql \
        --db-name=$DATABASE_NAME \
        --db-user=$DATABASE_USER \
        --db-password=$DATABASE_PASSWORD \
        --base-url=https://$VIRTUAL_HOST/ \
        --admin-firstname=Admin \
        --admin-lastname=Admin \
        --admin-email=admin@admin.com \
        --admin-user=$ADMIN_USER \
        --admin-password=$ADMIN_PASS \
        --language=es_AR \
        --currency=ARS \
        --timezone=America/Argentina/Buenos_Aires \
        --use-rewrites=1 $EXTRA_PARAMS

    # setting values
    for i in "$@"
    do
        case $i in
            --admin-user=*)
            ADMIN_USER="${i#*=}"
            shift # past argument=value
            ;;
            --admin-password=*)
            ADMIN_PASS="${i#*=}"
            shift # past argument=value
            ;;
            --base-url=*)
            VIRTUAL_HOST="${i#*=}"
            shift # past argument=value
            ;;
            *)
            # unknown option
            ;;
        esac;
    done;

    warp_message "Docker development environment setup complete."
    warp_message "You may now access your Magento instance at https://${VIRTUAL_HOST}/"
    warp_message "Admin user: $ADMIN_USER"
    warp_message "Admin pass: $ADMIN_PASS"
}

function magento_config_redis()
{
    warp_message "Configure redis"

    REDIS_CACHE_VERSION=$(warp_env_read_var REDIS_CACHE_VERSION)
    REDIS_FPC_VERSION=$(warp_env_read_var REDIS_FPC_VERSION)
    REDIS_SESSION_VERSION=$(warp_env_read_var REDIS_SESSION_VERSION)

    if [ ! -z "$REDIS_CACHE_VERSION" ]
    then
        warp_message "Enabling redis for cache..."
        warp magento setup:config:set --no-interaction --cache-backend=redis --cache-backend-redis-server=redis-cache --cache-backend-redis-db=0
    fi

    if [ ! -z "$REDIS_FPC_VERSION" ]
    then
        warp_message "Enabling redis for full page cache..."
        warp magento setup:config:set --no-interaction --page-cache=redis --page-cache-redis-server=redis-fpc --page-cache-redis-db=1
    fi

    if [ ! -z "$REDIS_SESSION_VERSION" ]
    then
        warp_message "Enabling Redis for session..."
        warp magento setup:config:set --no-interaction --session-save=redis --session-save-redis-host=redis-session --session-save-redis-log-level=4 --session-save-redis-db=1
    fi
}

function magento_download()
{
    # Download Magento Community

    [ -z "$1" ] && echo "Please specify the version to download (ex. 2.0.0)" && exit
    curl -L http://pubfiles.nexcess.net/magento/ce-packages/magento2-$1.tar.gz | tar xzf - -o -C .

    # Add include/exclude files to gitignore
    warp_check_gitignore
}

function magento_config_varnish()
{
    USE_VARNISH=$(warp_env_read_var USE_VARNISH)
    VARNISH_VERSION=$(warp_env_read_var VARNISH_VERSION)

    if [[ "$USE_VARNISH" = "Y" || "$USE_VARNISH" = "y" ]]
    then
        warp_message "Configure varnish"

        if [ $VARNISH_VERSION = "5.2.1" ] ; then
            EXPORT_VARNISH_VERSION="5"
        else
            EXPORT_VARNISH_VERSION="4"
        fi;

        warp magento config:set --scope=default --scope-code=0 system/full_page_cache/caching_application 2
        warp magento setup:config:set --http-cache-hosts=web
        warp magento varnish:vcl:generate --backend-host=web --backend-port=80 --access-list=web --export-version=${EXPORT_VARNISH_VERSION} > ${CONFIGFOLDER}/varnish/default.vcl

        # search and clear .probe { .. }
        perl -i -p0e 's/.probe.*?}//s' ${CONFIGFOLDER}/varnish/default.vcl

        warp_message "Done!"
    else
        warp_message "Varnish is not configured or disabled"
    fi;
}

function magento_config_smile()
{
    warp_message "Setting up Smile"

    warp magento config:set -l smile_elasticsuite_core_base_settings/es_client/servers elasticsearch:9200
    warp magento config:set -l smile_elasticsuite_core_base_settings/es_client/enable_https_mode 0
    warp magento config:set -l smile_elasticsuite_core_base_settings/es_client/enable_http_auth 0
    warp magento config:set -l smile_elasticsuite_core_base_settings/es_client/http_auth_user ""
    warp magento config:set -l smile_elasticsuite_core_base_settings/es_client/http_auth_pwd ""
    warp magento app:config:import
}

function magento_generate_fixtures()
{   
    warp magento setup:perf:generate-fixtures /var/www/html/setup/performance-toolkit/profiles/ce/small.xml
}

function magento_config_developer_mode()
{    
    VIRTUAL_HOST=$(warp_env_read_var VIRTUAL_HOST)
    
    warp_message "Turning on developer mode.."
    warp magento deploy:mode:set developer

    warp_message "Setting up https"
    warp magento setup:store-config:set --use-secure-admin=1
    warp magento setup:store-config:set --base-url="https://${VIRTUAL_HOST}/"
    warp magento setup:store-config:set --base-url-secure="https://${VIRTUAL_HOST}/"

    warp_message "Disable Admin session Lifetime"
    warp magento config:set -l admin/security/session_lifetime 31536000
    
    warp_message "Disable Captcha Admin"
    warp magento config:set -l admin/captcha/enable 0

    warp_message "Flush Magento cache"
    warp magento cache:flush
}

function magento_main()
{
    case "$1" in
        magento)
            shift 1
            magento_command $*
        ;;

        -h | --help)
            magento_help_usage
        ;;

        *)            
            magento_help_usage
        ;;
    esac
}