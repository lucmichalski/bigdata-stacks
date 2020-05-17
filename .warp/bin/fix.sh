#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/fix_help.sh"

function fix_add_user()
{
    case "$(uname -s)" in
      Darwin)
        warp_message "* this command is not necessary for macOS $(warp_message_ok [ok])"
      ;;
      Linux)
        warp_message "* Adding host user: $(whoami) to docker and www-data groups $(warp_message_ok [ok])"

        # add user docker to current user
        sudo usermod -aG docker $(whoami)

        # add ID user 33 (www-data inside container) to current user
        sudo usermod -aG 33 $(whoami)

      ;;
    esac

    exit 1;
}

function fix_php()
{

    warp_message "* Applying permissions for php logs .warp/docker/volumes/php-fpm $(warp_message_ok [ok])"

    # add permission php logs

    [ -d $PROJECTPATH/.warp/docker/volumes/php-fpm/ ] && sudo chmod -R a+rwx $PROJECTPATH/.warp/docker/volumes/php-fpm
    [ -d $PROJECTPATH/.warp/docker/volumes/php-fpm/ ] && sudo chgrp -R 33 $PROJECTPATH/.warp/docker/volumes/php-fpm

    exit 1;
}

function fix_elasticsearch()
{
    warp_message "* Applying permissions to subdirectories .warp/docker/volumes/elasticsearch $(warp_message_ok [ok])"

    mkdir -p   $PROJECTPATH/.warp/docker/volumes/elasticsearch
    sudo chmod -R a+rwx $PROJECTPATH/.warp/docker/volumes/elasticsearch*
    sudo chown -R 102:102 $PROJECTPATH/.warp/docker/volumes/elasticsearch*

    exit 1;
}

function fix_grunt()
{

    warp_message "* Applying permissions $(warp_message_ok [ok])"
    sudo find $PROJECTPATH/pub -type d -exec chmod ug+rwx {} \; # Make folders traversable and read/write

    warp_message "* Make files read/write $(warp_message_ok [ok])"
    sudo find $PROJECTPATH/pub -type f -exec chmod a+rw {} \;  # Make files read/write

    warp_message "* Deleting var/cache $(warp_message_ok [ok])"
    [ -d $PROJECTPATH/var/cache ] && sudo rm -rf $PROJECTPATH/var/cache

    exit 1;
}

function fix_mysql()
{
    warp_message "* Applying user (mysql) and group (mysql) to MySQL container $(warp_message_ok [ok])"

    # add permission MySQL 999 (mysql inside the container)
    [ -d $PROJECTPATH/.warp/docker/volumes/mysql/ ] && sudo chown -R 999:999 $PROJECTPATH/.warp/docker/volumes/mysql/

    exit 1;
}

function fix_composer()
{
    warp_message "* chmod() permission correction"

    # add user & group www-data on bin/magento binary
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/bin/magento ] && chown www-data:www-data /var/www/html/bin/magento"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/html/vendor ] && chown -R www-data:www-data /var/www/html/vendor"

    # add user & group www-data on /var/www/.composer
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chown $(id -u):33 /var/www/.composer"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chmod ug+rwx /var/www/.composer"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chown -R $(id -u):33 /var/www/.composer"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chmod -R ug+rw /var/www/.composer"

    # add read/write and group www-data on hidden files
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find . -maxdepth 1 -type f -exec chown $(id -u):33 {} \;"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find . -maxdepth 1 -type f -exec chmod ug+rw {} \;"

    warp_message "* Success $(warp_message_ok [ok])"

    exit 1;
}

function fix_fast()
{
    # add user & group www-data on bin/magento binary
    warp_message "* Correcting read/write filesystem permissions"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/html/ ] && chmod -R ug+rw /var/www/html/"

    warp_message "* Correcting filesystem ownerships"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/html/ ] && chown -R $(id -u):33 /var/www/html/"

    warp_message "* Add user and group www-data to vendor"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/html/vendor ] && chown -R www-data:www-data /var/www/html/vendor"

    if [ -f $PROJECTPATH/bin/magento ]
    then
      warp_message "* Correcting permissions on bin/magento"
      docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/bin/magento ] && chown www-data:www-data /var/www/html/bin/magento"
      docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/bin/magento ] && chmod +x /var/www/html/bin/magento"
    fi;

    if [ -f $PROJECTPATH/bin/console ]
    then
        warp_message "* Correcting permissions on bin/console"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/bin/console ] && chown www-data:www-data /var/www/html/bin/console"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/bin/console ] && chmod +x /var/www/html/bin/console"
    elif [ -f $PROJECTPATH/app/console ] ; then
        warp_message "* Correcting permissions on app/console"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/app/console ] && chown www-data:www-data /var/www/html/app/console"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/app/console ] && chmod +x /var/www/html/app/console"
    fi

    warp_message "* Success $(warp_message_ok [ok])"
    exit 1;
}

function fix_owner()
{
    if [ ! -z "$2" ] ; then 
        warp_message "* Correcting filesystem ownerships on \"$2\"..."
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find $2 -not -path '*/\.*' -exec chgrp -R 33 {} \;"

        warp_message "* Correcting filesystem permissions on \"$2\"..."
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find $2 -type f -not -path '*/\.*' -exec chmod a+rw {} \;"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find $2 -type d -not -path '*/\.*' -exec chmod ug+rwx {} \;"
    else
        warp_message "* Correcting filesystem ownerships..."
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find . -not -path '*/\.*' -exec chgrp -R 33 {} \;"

        warp_message "* Correcting filesystem permissions..."
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find .* -maxdepth 0 -type f -exec chmod a+rw {} \;"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find . -type f -not -path '*/\.*' -exec chmod a+rw {} \;"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find . -type d -not -path '*/\.*' -exec chmod ug+rwx {} \;"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/bin/magento ] && chown www-data:www-data /var/www/html/bin/magento"
    fi

    warp_message "* Filesystem permissions corrected."
}

function fix_sandbox()
{
    warp_message "* Correcting filesystem ownerships..."
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "chgrp -R 33 /var/www/html/"

    warp_message "* Correcting filesystem permissions..."
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "chmod -R ug+rw /var/www/html/"

    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/2.2.9-ce/bin/magento ] && chown www-data:www-data /var/www/html/2.2.9-ce/bin/magento"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/2.3.1-ce/bin/magento ] && chown www-data:www-data /var/www/html/2.3.1-ce/bin/magento"

    warp_message "* Filesystem permissions corrected."
}

function fix_default()
{
    # fix user and groups to current project
    warp_message "* Applying user: $(whoami) and group: www-data to files and folders $(warp_message_ok [ok])"
    case "$(uname -s)" in
      Darwin)
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "chown 33:33 /var/www/html/"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "chmod ug+rwx /var/www/html/"
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "chown -R $(id -u):33 /var/www/html/*"
      ;;
      Linux)
        sudo chown -R $(whoami):33 $(ls)
      ;;
    esac

    # set permission on root folder /var/www/html
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "chown $(id -u):33 /var/www/html/"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "chmod ug+rwx /var/www/html/"

    # add read/write and group www-data on hidden files
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find . -maxdepth 1 -type f -exec chown $(id -u):33 {} \;"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "cd /var/www/html/ ; find . -maxdepth 1 -type f -exec chmod ug+rw {} \;"

    warp_message "* Make folders traversable and read/write $(warp_message_ok [ok])"
    case "$(uname -s)" in
      Darwin)
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "find /var/www/html/ -type d -exec chmod ug+rwx {} \;"
      ;;
      Linux)
        sudo find $(ls) -type d -exec chmod ug+rwx {} \; # Make folders traversable and read/write
      ;;
    esac

    warp_message "* Make files read/write $(warp_message_ok [ok])"
    case "$(uname -s)" in
      Darwin)
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "find /var/www/html/ -type f -exec chmod a+rw {} \;"
      ;;
      Linux)
        sudo find $(ls) -type f -exec chmod a+rw {} \;  # Make files read/write
      ;;
    esac

    warp_message "* Applying permissions to subdirectories .warp/docker/volumes $(warp_message_ok [ok])"

    # add permission elasticsearch inside the container    
    [ -d $PROJECTPATH/.warp/docker/volumes/elasticsearch/ ] && sudo chmod -R a+rwx $PROJECTPATH/.warp/docker/volumes/elasticsearch*
    [ -d $PROJECTPATH/.warp/docker/volumes/php-fpm/ ] && sudo chmod -R a+rwx $PROJECTPATH/.warp/docker/volumes/php-fpm

    warp_message "* Applying permissions to binaries $(warp_message_ok [ok])"
    # restart correct permissions to warp and binaries
    [ -f $PROJECTPATH/warp ] && sudo chmod a+x $PROJECTPATH/warp
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -f /var/www/html/bin/magento ] && chown www-data:www-data /var/www/html/bin/magento"

    # workaround Magento 2.3.x
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/html/.github ] && chown www-data:www-data /var/www/html/.github"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/html/.github ] && chmod -R a+rw /var/www/html/.github"

    # add user & group www-data on /var/www/.composer
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chown $(id -u):33 /var/www/.composer"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chmod ug+rwx /var/www/.composer"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chown -R $(id -u):33 /var/www/.composer"
    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "[ -d /var/www/.composer ] && chmod -R ug+rw /var/www/.composer"
    warp_message "* Success $(warp_message_ok [ok])"
    exit 1;
}

function fix_permissions() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        fix_help_usage 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    case "$1" in
      "--addUser")
            fix_add_user 
            exit 1
      ;;
      "--php")
            fix_php
            exit 1
      ;;
      "--composer")
            fix_composer
            exit 1
      ;;
      "--grunt")
            fix_grunt
            exit 1
      ;;
      "--elasticsearch")
            fix_elasticsearch
            exit 1
      ;;
      "--mysql")
            fix_mysql
            exit 1
      ;;
      "--owner")
            fix_owner $@
            exit 1
      ;;
      "--fast"|"-f")
            fix_fast $@
            exit 1
      ;;
      "--sandbox")
            fix_sandbox $@
            exit 1
      ;;
      "--all")
            fix_php
            fix_mysql
            fix_elasticsearch
            fix_grunt
            fix_add_user
            exit 1
      ;;
      *)
            fix_default
      ;;      
    esac
}

function fix_main()
{
    case "$1" in
        fix)
            shift 1
            fix_permissions $*
        ;;

        -h | --help)
            fix_help_usage
        ;;

        *)            
            fix_help_usage
        ;;
    esac
}