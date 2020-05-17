#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/sandbox_help.sh"

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
function sandbox_command() {
    echo ""
    warp_banner
    echo ""

    if [ -f $DOCKERCOMPOSEFILE ] || [ -f $ENVIRONMENTVARIABLESFILESAMPLE ]; then

        if [ ! -f $ENVIRONMENTVARIABLESFILE ]; then
            # INIT WIZARD MODE SANDBOX DEVELOPER
            . "$WARPFOLDER/setup/init/sandbox-developer.sh"
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

            if [ -f $DOCKERCOMPOSEFILEDEV ]; then
                echo "* Checking file $(basename $DOCKERCOMPOSEFILEDEV) $(warp_message_ok [ok])"
            else
                INFRA_FILES_ERROR="TRUE"
                echo "* Checking file $(basename $DOCKERCOMPOSEFILEDEV) $(warp_message_error [error])"
            fi;

            if [ $INFRA_FILES_ERROR = "TRUE" ]; then
                warp_message_warn "-- These files: ($(basename $DOCKERCOMPOSEFILE) and $(basename $ENVIRONMENTVARIABLESFILE) and $(basename $DOCKERCOMPOSEFILEDEV)) are necessary to initialize the containers.. $(warp_message_error [error])"
                exit
            fi
        fi
    else
        # INIT WIZARD MODE TL
        warp_message_info "* Starting initial installation\n"
        . "$WARPFOLDER/setup/sandbox/sandbox-m2.sh"
    fi;
}

function sandbox_start() {

  docker-compose -f $DOCKERCOMPOSEFILE -f $DOCKERCOMPOSEFILEDEV up --remove-orphans -d
}

function sandbox_stop() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      sandbox_stop_help
      exit 0;
  fi

  if [ "$1" = "--hard" ] ; then
    DOCKERACTION="down --remove-orphans"
  else
    DOCKERACTION=stop
  fi;

  docker-compose -f $DOCKERCOMPOSEFILE $DOCKERACTION
}

function sandbox_restart() {
  warp sandbox stop
  warp sandbox start
}

function sandbox_remove() {
  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      sandbox_remove_help
      exit 0;
  fi

  warp reset --hard

  rm -rf $PROJECTPATH/.dockerignore 2> /dev/null
  sudo rm -rf $PROJECTPATH/.warp/ 2> /dev/null
}

function sandbox_ssh() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$2" = "-h" ] || [ "$2" = "--help" ] ; then      
      sandbox_ssh_help
      exit 0;
  fi

  if [ "$2" = "--root" ]
  then
    SSH_OPTION="-uroot"
  else
    SSH_OPTION=""
  fi

  case "$1" in
      php71)
          docker-compose -f $DOCKERCOMPOSEFILE exec $SSH_OPTION php71 bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash" 
      ;;

      php72)
          docker-compose -f $DOCKERCOMPOSEFILE exec $SSH_OPTION php72 bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
      ;;

      --root)
          docker-compose -f $DOCKERCOMPOSEFILE exec -uroot php bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
      ;;

      *)            
          docker-compose -f $DOCKERCOMPOSEFILE exec php bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
      ;;
  esac
}

function sandbox_push() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      push_help_usage
      exit 0;
  fi

  if [ $(warp_check_is_running) = false ]; then
    warp_message_error "The containers are not running"
    warp_message_error "please, first run warp start"

    exit 1;
  fi

  [ -z "$1" ] && warp_message_error "Please specify a directory or file to copy to container (ex. vendor, --all)" && exit
  CONTAINER_PHP_NAME=$(docker-compose -f $DOCKERCOMPOSEFILE ps|grep php72|awk '{print $1}')

  if [ "$1" == "--all" ]; then
    docker cp ./.platform/./ $CONTAINER_PHP_NAME:/var/www/html
    echo "Completed copying all files from host to container"    
  else
    docker cp ./.platform/$1 $CONTAINER_PHP_NAME:/var/www/html
    echo "Completed copying $1 from host to container"    
  fi  

  # fix permissions
  if [ $# -eq 1 ] ; then
    warp fix --sandbox $1
  else
    [ $# -ge 2 ] && warp fix --sandbox
  fi;     
}

function sandbox_pull() {

  if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then      
      pull_help_usage
      exit 0;
  fi

  if [ $(warp_check_is_running) = false ]; then
    warp_message_error "The containers are not running"
    warp_message_error "please, first run warp start"

    exit 1;
  fi

  [ -z "$1" ] && warp_message_error "Please specify a directory or file to copy from container (ex. vendor, --all)" && exit
  CONTAINER_PHP_NAME=$(docker-compose -f $DOCKERCOMPOSEFILE ps|grep php72|awk '{print $1}')

  if [ "$1" == "--all" ]; then
    docker cp $CONTAINER_PHP_NAME:/var/www/html/./ ./.platform
    warp_message "Completed copying all files from container to host"
    warp fix --sandbox
  else
    
    for i in "$@"
    do
      if [ -f $i ] || [ -d $i ] ; then
        docker cp $CONTAINER_PHP_NAME:/var/www/html/$i ./.platform
        warp_message "Completed copying $i from container to host"
      else
        warp_message_error "do not copy $i from host to container"  
      fi
    done;    

    # fix permissions
    if [ $# -eq 1 ] ; then
      warp fix --sandbox $1
    else
      [ $# -ge 2 ] && warp fix --sandbox
    fi;     
  fi  
}

function sandbox_install() {

  if [ $(warp_check_is_running) = false ]; then
    warp_message "starting containers, please wait"
    warp sandbox start
    sleep 6
  fi

  . "$WARPFOLDER/setup/sandbox/m2-install.sh"
}

function sandbox_main()
{
    case "$1" in
        init)
          sandbox_command $*
        ;;

        start)
          sandbox_start $*
        ;;

        stop)
          shift 1
          sandbox_stop $*
        ;;

        restart)
          shift 1
          sandbox_restart $*
        ;;

        push)
          shift 1
          sandbox_push $*
        ;;

        pull)
          shift 1
          sandbox_pull $*
        ;;

        ssh)
          shift 1
          sandbox_ssh $*
        ;;

        remove | rm)
          shift 1
          sandbox_remove $*
        ;;

        php71)
          shift 1
          warp sandbox ssh php71 $*
        ;;

        php72)
          shift 1
          warp sandbox ssh php72 $*
        ;;

        --install)
          shift 1
          sandbox_install $*
        ;;

        *)
          sandbox_help_usage
        ;;
    esac
}
