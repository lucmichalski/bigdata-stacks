#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/npm_help.sh"

function npm_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        npm_help_usage 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "npm $*"
}

function npm_main()
{
    case "$1" in
        npm)
            shift 1
            npm_command $*
        ;;

        -h | --help)
            npm_help_usage
        ;;

        *)            
            npm_help_usage
        ;;
    esac
}