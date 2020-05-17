#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/crontab_help.sh"

# Initialize Cron Job
function crontab_run() {

    docker-compose -f $DOCKERCOMPOSEFILE exec -d --user=root php bash -c "chown root:root /etc/cron.d/* && chmod 644 /etc/cron.d/* && cron"
}

function crontab() {

  if [ "$*" = "crontab -h" ] || [ "$*" = "crontab --help" ] ; then      

      crontab_help_usage
      exit 0;
  fi

  if [ $(warp_check_is_running) = false ]; then
    warp_message_error "The containers are not running"
    warp_message_error "please, first run warp start"

    exit 1;
  fi

  
  if [ "$*" = "crontab -e" ] ; then

    docker-compose -f $DOCKERCOMPOSEFILE exec --user=root php bash -c "vim /etc/cron.d/cronfile"
  elif [ "$*" = "crontab -l" ] ; then

    docker-compose -f $DOCKERCOMPOSEFILE exec php bash -c "cat /etc/cron.d/cronfile"
  else

    crontab_help_usage
  fi;

}

function crontab_main()
{
    case "$1" in
        crontab)
          crontab $*
        ;;

        -h | --help)
            crontab_help_usage
        ;;

        *)
		      crontab_help_usage
        ;;
    esac
}
