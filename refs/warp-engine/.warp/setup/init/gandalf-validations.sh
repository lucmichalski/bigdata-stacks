#!/bin/bash +x

let CHECK_GANDALF_ERRORS=0

if [[ -z $GF_NGINX_VHOST ]]
then
    warp_message_info2 "--vhost is a required parameter"
    let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
fi

if [[ ! -z $GF_PHP_VERSION ]]
then
    case $GF_PHP_VERSION in
        '5.6-fpm'|'7.0-fpm'|'7.1-fpm'|'7.2-fpm'|'7.3-fpm'|'7.4-fpm'|'7.1.17-fpm'|'7.1.26-fpm')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_PHP_VERSION, the available versions are 5.6-fpm, 7.0-fpm, 7.1-fpm, 7.2-fpm, 7.3-fpm, 7.4-fpm, 7.1.17-fpm, 7.1.26-fpm"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

if [[ ! -z $GF_FRAMEWORK ]]
then
    case $GF_FRAMEWORK in
        'm1'|'m2'|'oro'|'php')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_FRAMEWORK, the available options are m1, m2, oro, php"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

if [[ ! -z $GF_MYSQL_VERSION ]]
then
    case $GF_MYSQL_VERSION in
        '5.6'|'5.7')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_MYSQL_VERSION, the available versions are 5.6, 5.7"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

if [[ ! -z $GF_POSTGRES_VERSION ]]
then
    case $GF_POSTGRES_VERSION in
        '9.6.15')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_POSTGRES_VERSION, the available version is 9.6.15"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

if [[ ! -z $GF_ELASTICSEARCH_VERSION ]]
then
    case $GF_ELASTICSEARCH_VERSION in
        '7.6.2'|'6.5.4'|'6.4.2'|'5.6.8'|'2.4.6'|'2.4.4'|'1.7.6')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_ELASTICSEARCH_VERSION, the available versions are: 7.6.2, 6.5.4, 6.4.2, 5.6.8, 2.4.6, 2.4.4, 1.7.6"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

if [[ ! -z $GF_REDIS_VERSION ]]
then
    case $GF_REDIS_VERSION in
        '3.2.10-alpine'|'4.0'|'5.0')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_REDIS_VERSION, the available versions are: 3.2.10-alpine, 4.0, 5.0"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

if [[ ! -z $GF_RABBIT_VERSION ]]
then
    case $GF_RABBIT_VERSION in
        '3.7-management')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_RABBIT_VERSION, the available version is 3.7-management"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

if [[ ! -z $GF_MAILHOG ]]
then
    let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
fi

if [[ ! -z $GF_VARNISH_VERSION ]]
then
    case $GF_VARNISH_VERSION in
        '4.0.5'|'5.2.1')
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS
        ;;
        *)
            warp_message_info2 "Selected: $GF_VARNISH_VERSION, the available versions are: 4.0.5, 5.2.1"
            let CHECK_GANDALF_ERRORS=$CHECK_GANDALF_ERRORS+1
        ;;
    esac
fi

[ $CHECK_GANDALF_ERRORS -eq 1 ] && warp_message_error "$CHECK_GANDALF_ERRORS error was found, check options." && exit 1;
[ $CHECK_GANDALF_ERRORS -gt 1 ] && warp_message_error "$CHECK_GANDALF_ERRORS errors were found, check options." && exit 1;