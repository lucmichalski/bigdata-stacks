#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/sync_help.sh"

function push_to_container() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      push_help_usage
      exit 0;
  fi

  if [ $(warp_check_is_running) = false ]; then
    warp_message_error "The containers are not running"
    warp_message_error "please, first run warp start"

    exit 1;
  fi

  case "$(uname -s)" in
    Linux)
      warp_message_error "these commands are available only on mac"
      exit 1;
    ;;
    Darwin)
    # autodetect docker in Mac
    # Check availability of docker-sync
    hash docker-sync 2>/dev/null || { echo >&2 "warp framework requires \"docker-sync\". Please run \"sudo gem install docker-sync -n /usr/local/bin\"  "; exit 1; }
    ;;
  esac

  [ -z "$1" ] && warp_message_error "Please specify a directory or file to copy to container (ex. vendor, --all)" && exit
  CONTAINER_PHP_NAME=$(docker-compose -f $DOCKERCOMPOSEFILE ps -q php)

  if [ "$1" == "--all" ]; then
    docker cp ./ $CONTAINER_PHP_NAME:/var/www/html
    warp_message "Completed copying all files from host to container"
    warp fix --owner
  else
    
    for i in "$@"
    do
      if [ -f $i ] || [ -d $i ] ; then
        docker cp ./$i $CONTAINER_PHP_NAME:/var/www/html
        warp_message "Completed copying $i from host to container"  
      else
        warp_message_error "do not copy $i from host to container"  
      fi
    done;    

    # fix permissions
    if [ $# -eq 1 ] ; then
      warp fix --owner $1
    else
      [ $# -ge 2 ] && warp fix --owner
    fi;     
  fi  
}

function pull_from_container() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      pull_help_usage
      exit 0;
  fi

  if [ $(warp_check_is_running) = false ]; then
    warp_message_error "The containers are not running"
    warp_message_error "please, first run warp start"

    exit 1;
  fi

  case "$(uname -s)" in
    Linux)
      warp_message_error "these commands are available only on mac"
      exit 1;
    ;;
    Darwin)
    # autodetect docker in Mac
    # Check availability of docker-sync
    hash docker-sync 2>/dev/null || { echo >&2 "warp framework requires \"docker-sync\". Please run \"sudo gem install docker-sync -n /usr/local/bin\"  "; exit 1; }
    ;;
  esac

  [ -z "$1" ] && warp_message_error "Please specify a directory or file to copy from container (ex. vendor, --all)" && exit
  CONTAINER_PHP_NAME=$(docker-compose -f $DOCKERCOMPOSEFILE ps -q php)

  if [ "$1" == "--all" ]; then
    docker cp $CONTAINER_PHP_NAME:/var/www/html/./ ./
    warp_message "Completed copying all files from container to host"
  else
    for i in "$@"
    do
        docker cp $CONTAINER_PHP_NAME:/var/www/html/$i ./
        warp_message "Completed copying $i from container to host"
    done;    
  fi  
}

function warp_clean_volume()
{
  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      clean_help_usage
      exit 0;
  fi

  case "$(uname -s)" in
    Linux)
      warp_message_error "these commands are available only on mac"
      exit 1;
    ;;
    Darwin)
    # autodetect docker in Mac
    # Check availability of docker-sync
    hash docker-sync 2>/dev/null || { echo >&2 "warp framework requires \"docker-sync\". Please run \"sudo gem install docker-sync -n /usr/local/bin\"  "; exit 1; }
    ;;
  esac

  docker-sync clean
}

function sync_main()
{
    case "$1" in
        push)
		      shift 1
          push_to_container $*  
        ;;

        pull)
		      shift 1
          pull_from_container $*  
        ;;

        clean)
          warp_clean_volume $*
        ;;

        -h | --help)
            sync_help_usage
        ;;

        *)
		      sync_help_usage
        ;;
    esac
}
