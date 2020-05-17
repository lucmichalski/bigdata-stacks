#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/xdebug_help.sh"

function xdebug_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        xdebug_help_usage 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    if [ "$1" == "--disable" ]; then
        sed -i -e 's/^zend_extension/\;zend_extension/g' $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini
        warp docker stop php 
        warp docker start php 
        warp_message "Xdebug has been disabled."    
    elif [ "$1" == "--enable" ]; then
        sed -i -e 's/^\;zend_extension/zend_extension/g' $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini
        warp docker stop php 
        warp docker start php 
        warp_message "Xdebug has been enabled."    
    elif [ "$1" == "--status" ]; then
            [ -f $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini ] && cat $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini | grep --quiet -w "^;zend_extension"

            # Exit status 0 means string was found
            # Exit status 1 means string was not found
            if [ $? = 1 ] ; then
                warp_message "Xdebug is enabled."    
            else
                warp_message "Xdebug is disabled."    
            fi;
    else
        warp_message_warn "Please specify either '--enable', '--disable', '--status' as an argument"
    fi
}

function xdebug_main()
{
    case "$1" in
        --enable)
            xdebug_command $*
        ;;

        --disable)
            xdebug_command $*
        ;;

        --status)
            xdebug_command $*
        ;;

        -h | --help)
            xdebug_help_usage
        ;;

        *)            
            xdebug_help_usage
        ;;
    esac
}