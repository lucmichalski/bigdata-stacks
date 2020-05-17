#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/ioncube_help.sh"

function ioncube_command() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        ioncube_help_usage 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    if [ "$1" == "--disable" ]; then
        sed -i -e 's/^zend_extension/\;zend_extension/g' $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini
        warp docker stop php 
        warp docker start php 
        warp_message "ionCube has been disabled."    
    elif [ "$1" == "--enable" ]; then
        sed -i -e 's/^\;zend_extension/zend_extension/g' $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini
        warp docker stop php 
        warp docker start php 
        warp_message "ionCube has been enabled."    
    elif [ "$1" == "--status" ]; then
            [ -f $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini ] && cat $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini | grep --quiet -w "^;zend_extension"

            # Exit status 0 means string was found
            # Exit status 1 means string was not found
            if [ $? = 1 ] ; then
                warp_message "ionCube is enabled."    
            else
                warp_message "ionCube is disabled."    
            fi;
    else
        warp_message_warn "Please specify either '--enable', '--disable', '--status' as an argument"
    fi
}

function ioncube_main()
{
    case "$1" in
        --enable)
            ioncube_command $*
        ;;

        --disable)
            ioncube_command $*
        ;;

        --status)
            ioncube_command $*
        ;;

        -h | --help)
            ioncube_help_usage
        ;;

        *)            
            ioncube_help_usage
        ;;
    esac
}