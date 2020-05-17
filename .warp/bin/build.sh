#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/build_help.sh"

function build_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        build_help_usage 
        exit 1
    fi;

    if [ $# -eq 0 ] # check if not argument
    then
        build_help_usage 
        exit 1
    else
        docker build $*
    fi;
}

function build_main()
{
    case "$1" in
        build)
            shift 1
            build_command $*
        ;;

        -h | --help)
            build_help_usage
        ;;

        *)            
            build_help_usage
        ;;
    esac
}