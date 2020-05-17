#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/restart_help.sh"

#######################################
# Stop the server
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None

##-c ####################-c #################
function restart_command() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
        
      restart_help_usage
  else
    stop_main stop
    start_main start
  fi;

}

function restart_main()
{
    case "$1" in
        restart)
          shift 1
          restart_command $*
        ;;

        *)
          restart_help_usage
        ;;
    esac
}
