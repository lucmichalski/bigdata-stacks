#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/mailhog_help.sh"

function mailhog_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi; 

    MAILHOG_BINDED_PORT=$(warp_env_read_var MAILHOG_BINDED_PORT)

    if [ ! -z "$MAILHOG_BINDED_PORT" ]
    then
        warp_message ""
        warp_message_info "* Mailhog Server "
        warp_message "Host SMTP:                  $(warp_message_info 'mailhog')"
        warp_message "Port (container):           $(warp_message_info '1025')"
        warp_message "Access browser:             $(warp_message_info 'http://127.0.0.1:'$MAILHOG_BINDED_PORT)"
        warp_message ""
    fi

}

function mailhog_main()
{
    case "$1" in
        info)
            mailhog_info
        ;;

        -h | --help)
            mailhog_help_usage
        ;;

        *)            
            mailhog_help_usage
        ;;
    esac
}