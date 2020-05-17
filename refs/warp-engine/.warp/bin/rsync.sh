#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/rsync_help.sh"

function rsync_push_to_container() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      rsync_push_help_usage
      exit 0;
  fi

  if [ $(warp_check_is_running) = false ]; then
    warp_message_error "The containers are not running"
    warp_message_error "please, first run warp start"

    exit 1;
  fi

  # Check rsync is installed
  hash rsync 2>/dev/null || warp_rsync_is_not_installed  
  warp_check_rsync_version

  [ -z "$1" ] && warp_message_error "Please specify a directory or file to copy to container (ex. vendor, --all)" && exit
  CONTAINER_APPDATA_PORT=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "873/tcp") 0).HostPort}}' $(warp docker ps -q appdata))

  if [ "$1" == "--all" ]; then
    rsync -aogvEh * --chown=$(id -u):33 --chmod=ug+rw rsync://localhost:$CONTAINER_APPDATA_PORT/warp
    warp_message "Completed copying all files from host to container"
    warp_message_warn "after this command is recommend to run \"warp fix --fast\" to solve problems with permissions"
  else
    
    for i in "$@"
    do
      if [ -f $i ] || [ -d $i ] ; then
        rsync -aogvEh $i --chown=$(id -u):33 --chmod=ug+rw rsync://localhost:$CONTAINER_APPDATA_PORT/warp
        warp_message "Completed copying $i from host to container"  
      else
        warp_message_error "do not copy $i from host to container"  
      fi
    done;    
  fi  
}

function rsync_pull_from_container() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      rsync_pull_help_usage
      exit 0;
  fi

  if [ $(warp_check_is_running) = false ]; then
    warp_message_error "The containers are not running"
    warp_message_error "please, first run warp start"

    exit 1;
  fi

  # Check rsync is installed
  hash rsync 2>/dev/null || warp_rsync_is_not_installed
  warp_check_rsync_version

  [ -z "$1" ] && warp_message_error "Please specify a directory or file to copy from container (ex. vendor, --all)" && exit
  CONTAINER_APPDATA_PORT=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "873/tcp") 0).HostPort}}' $(warp docker ps -q appdata))

  if [ "$1" == "--all" ]; then
    rsync -aogvEh rsync://localhost:$CONTAINER_APPDATA_PORT/warp .
    warp_message "Completed copying all files from container to host"
  else
    for i in "$@"
    do  
        rsync -aogvEh rsync://localhost:$CONTAINER_APPDATA_PORT/warp/$i .
        warp_message "Completed copying $i from container to host"
    done;    
  fi  
}

function rsync_main()
{
    case "$1" in
        push)
		      shift 1
          rsync_push_to_container $*  
        ;;

        pull)
		      shift 1
          rsync_pull_from_container $*  
        ;;

        -h | --help)
            rsync_help_usage
        ;;

        *)
		      rsync_help_usage
        ;;
    esac
}
