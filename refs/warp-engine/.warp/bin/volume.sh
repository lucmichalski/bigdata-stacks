#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/volume_help.sh"

function volume_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        volume_help_usage 
        exit 1
    fi;

    if [ $(warp_check_is_running) = true ]; then
        warp_message_error "The containers are running"
        warp_message_error "please, first run warp stop --hard"

        exit 1;
    fi

    case "$1" in
        php)
            warp_message "stopping data from volume php"
            warp docker stop php
            warp docker kill php
            warp_message "removing data from volume php"
            docker volume rm ${PWD##*/}_${PWD##*/}-volume-sync 
        ;;

        mysql)
            warp_message "stopping data from volume mysql"
            warp docker stop mysql
            warp docker kill mysql
            warp_message "removing data from volume mysql"
            docker volume rm ${PWD##*/}_${PWD##*/}-volume-db 
        ;;

        *)            
            warp_message_warn "Please specify either 'php', 'mysql' as an argument"
        ;;
    esac
}

function volume_main()
{
    case "$1" in
        --rm)
            shift 1
            volume_command $*
        ;;

        *)            
            volume_help_usage
        ;;
    esac
}