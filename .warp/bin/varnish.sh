#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/varnish_help.sh"

function varnish_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit 0;
    fi; 

    USE_VARNISH=$(warp_env_read_var USE_VARNISH)
    VARNISH_VERSION=$(warp_env_read_var VARNISH_VERSION)

    if [ ! -z "$USE_VARNISH" ]
    then
        warp_message ""
        warp_message_info "* Varnish"
        warp_message "Version:                    $(warp_message_info $VARNISH_VERSION)"
        warp_message "container .host:            $(warp_message_info 'web')"
        warp_message "container .port:            $(warp_message_info '80')"
        warp_message "container acl purge:        $(warp_message_info 'web')"
        warp_message "vcl configuration file:     $(warp_message_info ${CONFIGFOLDER}/varnish/default.vcl)"

        warp_message ""
        warp_message_warn " - Configure your vcl file (default.vcl) with: $(warp_message_bold 'warp magento --config-varnish')"
        warp_message ""
    fi

}

function varnish_command()
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        varnish_help_usage 
        exit 0;
    fi;

}

function varnish_main()
{
    case "$1" in
        varnish)
		      shift 1
          varnish_command $*  
        ;;

        info)
            varnish_info
        ;;

        -h | --help)
            varnish_help_usage
        ;;

        *)
		    varnish_help_usage
        ;;
    esac
}
