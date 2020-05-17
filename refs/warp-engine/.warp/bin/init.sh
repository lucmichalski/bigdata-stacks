#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/init_help.sh"

#######################################
# Start the server and all of its
# components
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
function init_command() {
    echo ""
    warp_banner
    echo ""

    if [ -f $DOCKERCOMPOSEFILE ] || [ -f $ENVIRONMENTVARIABLESFILESAMPLE ]; then

        if [ ! -f $ENVIRONMENTVARIABLESFILE ]; then
            if [ "$1" = "-n" ] || [ "$1" = "--no-interaction" ] ; then
                # INIT WITHOUT WIZARD MODE
                . "$WARPFOLDER/setup/init/autoload.sh"
            else
                # INIT WIZARD MODE DEVELOPER
                . "$WARPFOLDER/setup/init/developer.sh"
            fi
        else
            INFRA_FILES_ERROR="FALSE"
            if [ -f $DOCKERCOMPOSEFILE ]; then
                echo "* Checking file $(basename $DOCKERCOMPOSEFILE) $(warp_message_ok [ok])"
            else
                INFRA_FILES_ERROR="TRUE"
                echo "* Checking file $(basename $DOCKERCOMPOSEFILE) $(warp_message_error [error])"
            fi; 
            
            if [ -f $ENVIRONMENTVARIABLESFILE ]; then
                echo "* Checking file $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_ok [ok])"
            else
                INFRA_FILES_ERROR="TRUE"
                echo "* Checking file $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_error [error])"
            fi;

            if [ $INFRA_FILES_ERROR = "TRUE" ]; then
                warp_message_warn "-- These files: ($(basename $DOCKERCOMPOSEFILE) and $(basename $ENVIRONMENTVARIABLESFILE)) are necessary to initialize the containers.. $(warp_message_error [error])"
                exit
            fi
        fi
    else
        # INIT WITHOUT WIZARD MODE GANDALF
        if [ "$1" = "-mg" ] || [ "$1" = "--mode-gandalf" ] ; then            
            . "$WARPFOLDER/setup/init/gandalf.sh"
            exit 1
        fi

        # INIT WIZARD MODE TL
        warp_message_info "* Starting initial installation\n"
        . "$WARPFOLDER/setup/init/service.sh"
        . "$WARPFOLDER/setup/init/base.sh"
        . "$WARPFOLDER/setup/mac/mac.sh"
        . "$WARPFOLDER/setup/webserver/webserver.sh"
        . "$WARPFOLDER/setup/php/php.sh"
        . "$WARPFOLDER/setup/init/volumes.sh"
        . "$WARPFOLDER/setup/mysql/database.sh"
        . "$WARPFOLDER/setup/postgres/postgres.sh"
        . "$WARPFOLDER/setup/elasticsearch/elasticsearch.sh"
        . "$WARPFOLDER/setup/redis/redis.sh"
        . "$WARPFOLDER/setup/rabbit/rabbit.sh"
        . "$WARPFOLDER/setup/mailhog/mailhog.sh"
        . "$WARPFOLDER/setup/varnish/varnish.sh"
        . "$WARPFOLDER/setup/volumes/volumes.sh"
        . "$WARPFOLDER/setup/networks/networks.sh"
        . "$WARPFOLDER/setup/init/info.sh"
    fi;
}

function init_main()
{
    case "$1" in
        init)
          shift 1
          init_command $*
        ;;

        *)
          init_help_usage
        ;;
    esac
}
