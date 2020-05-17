#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/oro_help.sh"

function oro_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        oro_help_usage 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    if [ -f "$PROJECTPATH/bin/console" ]
    then
        OROBIN='bin/console'
    elif [ -f "$PROJECTPATH/app/console" ] ; then
        OROBIN='app/console'
    else
        warp_message_error "Framework Oro not found"
        exit 1;
    fi

    if [ "$1" = "--root" ]
    then
        shift 1
        docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "$OROBIN $*"
    elif [ "$1" = "-T" ] ; then
        shift 1
        docker-compose -f $DOCKERCOMPOSEFILE exec -T php bash -c "$OROBIN $*"
    else

        docker-compose -f $DOCKERCOMPOSEFILE exec php bash -c "$OROBIN $*"
    fi
}

function oro_main()
{
    case "$1" in
        oro)
            shift 1
            oro_command $*
        ;;

        -h | --help)
            oro_help_usage
        ;;

        *)            
            oro_help_usage
        ;;
    esac
}