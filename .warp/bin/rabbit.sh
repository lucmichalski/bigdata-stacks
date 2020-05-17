#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/rabbit_help.sh"

function rabbit_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi; 

    RABBIT_VERSION=$(warp_env_read_var RABBIT_VERSION)
    RABBIT_BINDED_PORT=$(warp_env_read_var RABBIT_BINDED_PORT)
    RABBITMQ_DEFAULT_USER=$(warp_env_read_var RABBITMQ_DEFAULT_USER)
    RABBITMQ_DEFAULT_PASS=$(warp_env_read_var RABBITMQ_DEFAULT_PASS)

    if [ ! -z "$RABBIT_VERSION" ]
    then
        warp_message ""
        warp_message_info "* Rabbit "
        warp_message "Rabbit Version:             $(warp_message_info $RABBIT_VERSION)"
        warp_message "Host:                       $(warp_message_info 'rabbitmq')"
        warp_message "RABBIT_DATA:                $(warp_message_info $PROJECTPATH/.warp/docker/volumes/rabbit)"
#       warp_message "RABBIT_CONFIG:              $(warp_message_info $PROJECTPATH/.warp/docker/config/rabbitmq)"
        warp_message "Port (container):           $(warp_message_info '5672')"
        warp_message "Access browser:             $(warp_message_info 'http://127.0.0.1:'$RABBIT_BINDED_PORT)"
        warp_message "Access User:                $(warp_message_info $RABBITMQ_DEFAULT_USER)"
        warp_message "Access Password:            $(warp_message_info $RABBITMQ_DEFAULT_PASS)"
        warp_message ""
    fi

}

function rabbit_main()
{
    case "$1" in
        info)
            rabbit_info
        ;;

        -h | --help)
            rabbit_help_usage
        ;;

        *)            
            rabbit_help_usage
        ;;
    esac
}