#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/start_help.sh"

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
function start() {

  if [ $(warp_check_is_running) = true ]; then
    warp_message_warn "the containers are running";
    warp_message_warn "for stop, please run: warp stop";
    exit 1;
  fi

  MODE_SANDBOX=$(warp_env_read_var MODE_SANDBOX)
  if [ ! -z "$MODE_SANDBOX" ]
  then
      if [ "$MODE_SANDBOX" = "Y" ] || [ "$MODE_SANDBOX" = "y" ] ; then
        warp_message_warn "warp mode sandbox must be started run: $(warp_message_info2 'warp sandbox start')";
        exit 1;
      fi;
  fi

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
        
      start_help_usage
      exit 1;
  else

    # Check 
    warp_check_files

    if [ "$1" = "-f" ] || [ "$1" = "-F" ] ; then
      [ ! -f $2 ] && warp_message_error "Custom yml file $2 not exist" && exit 1;

      CUSTOM_YML_FILE=$2;      
    fi

    if [ "$1" = "--selenium" ] ; then
      CUSTOM_YML_FILE=$DOCKERCOMPOSEFILESELENIUM;      
    fi

    case "$(uname -s)" in
      Darwin)
        USE_DOCKER_SYNC=$(warp_env_read_var USE_DOCKER_SYNC)
        if [ "$USE_DOCKER_SYNC" = "Y" ] || [ "$USE_DOCKER_SYNC" = "y" ] ; then 
          # start data sync
          docker-sync start
        fi

        if [ ! -z $CUSTOM_YML_FILE ] ; then
          # start docker with custom yml file
          docker-compose -f $DOCKERCOMPOSEFILE -f $DOCKERCOMPOSEFILEMAC -f $CUSTOM_YML_FILE up --remove-orphans -d
        else
          # start docker containers in macOS
          docker-compose -f $DOCKERCOMPOSEFILE -f $DOCKERCOMPOSEFILEMAC up --remove-orphans -d
        fi
      ;;
      Linux)
        if [ ! -z $CUSTOM_YML_FILE ] ; then
          # start docker with custom yml file
          docker-compose -f $DOCKERCOMPOSEFILE -f $CUSTOM_YML_FILE up --remove-orphans -d
        else
          # start docker containers in linux
          docker-compose -f $DOCKERCOMPOSEFILE up --remove-orphans -d
        fi
      ;;
    esac

    if [ $(warp_check_php_is_running) = true ]
    then
      # COPY ID_RSA ./ssh
      copy_ssh_id
      # Initialize Cron Job
      crontab_run

      # Starting Supervisor service
      docker-compose -f $DOCKERCOMPOSEFILE exec -d --user=root php bash -c "service supervisor start 2> /dev/null"

    else
      warp_message_warn "Please Run ./warp composer --credential to copy the credentials"
    fi
  fi;
}

function start_main()
{
    case "$1" in
        start)
          shift 1
          start $*
        ;;

        *)
          start_help_usage
        ;;
    esac
}
