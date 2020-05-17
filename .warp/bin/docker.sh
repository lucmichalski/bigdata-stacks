#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/docker_help.sh"

function docker_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        docker_help_usage 
        exit 0;
    fi;

    if [ ! -f $DOCKERCOMPOSEFILE ]
    then
        warp_message_error "$DOCKERCOMPOSEFILE not found"
        exit 1;
    fi

    docker-compose -f $DOCKERCOMPOSEFILE $*
}

function docker_main()
{
    case "$1" in
        docker)
            shift 1
            docker_command $*
        ;;

        -h | --help)
            docker_help_usage
        ;;

        *)            
            docker_help_usage
        ;;
    esac
}