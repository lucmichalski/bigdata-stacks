#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/postgres_help.sh"

function postgres_info()
{

    if ! warp_check_env_file ; then
        warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
        exit
    fi; 

    POSTGRES_DB=$(warp_env_read_var POSTGRES_DB)
    POSTGRES_USER=$(warp_env_read_var POSTGRES_USER)
    POSTGRES_PASSWORD=$(warp_env_read_var POSTGRES_PASSWORD)
    POSTGRES_BINDED_PORT=$(warp_env_read_var POSTGRES_BINDED_PORT)
    POSTGRES_VERSION=$(warp_env_read_var POSTGRES_VERSION)

    if [ ! -z "$POSTGRES_DB" ]
    then
        warp_message ""
        warp_message_info "* PostgreSQL"
        warp_message "Database Name:              $(warp_message_info $POSTGRES_DB)"
        warp_message "Host: (container)           $(warp_message_info postgres)"
        warp_message "Username:                   $(warp_message_info $POSTGRES_USER)"
        warp_message "Password:                   $(warp_message_info $POSTGRES_PASSWORD)"
        warp_message "Binded port (host):         $(warp_message_info $POSTGRES_BINDED_PORT)"
        warp_message "Postgres version:           $(warp_message_info $POSTGRES_VERSION)"
        warp_message "Dumps folder (host):        $(warp_message_info $PROJECTPATH/.warp/docker/dumps)" 
        warp_message "Dumps folder (container):   $(warp_message_info /dumps)"
        warp_message ""
        warp_message_warn " - prevent to use 127.0.0.1 or localhost as database host.  Instead of 127.0.0.1 use: $(warp_message_bold 'postgres')"
        warp_message ""
    fi
}

function postgres_connect() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        postgres_connect_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    POSTGRES_DB=$(warp_env_read_var POSTGRES_DB)
    POSTGRES_USER=$(warp_env_read_var POSTGRES_USER)

    docker-compose -f $DOCKERCOMPOSEFILE exec postgres bash -c "psql -U$POSTGRES_USER $POSTGRES_DB"
}

function postgres_connect_ssh() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        postgres_ssh_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    docker-compose -f $DOCKERCOMPOSEFILE exec postgres bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
}

function postgres_dump() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        postgres_dump_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    POSTGRES_USER=$(warp_env_read_var POSTGRES_USER)

    db="$@"

    [ -z "$db" ] && warp_message_error "Database name is required" && exit 1
    
    docker-compose -f $DOCKERCOMPOSEFILE exec postgres bash -c "pg_dump -U $POSTGRES_USER $db 2> /dev/null"
}

function postgres_import()
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]
    then
        postgres_import_help 
        exit 1
    fi;

    if [ $(warp_check_is_running) = false ]; then
        warp_message_error "The containers are not running"
        warp_message_error "please, first run warp start"

        exit 1;
    fi

    db=$1

    [ -z "$db" ] && warp_message_error "Database name is required" && exit 1

    POSTGRES_USER=$(warp_env_read_var POSTGRES_USER)
    
    docker-compose -f $DOCKERCOMPOSEFILE exec -T postgres bash -c "psql -U $POSTGRES_USER $db 2> /dev/null"

}

function postgres_main()
{
    case "$1" in
        dump)
            shift 1
            postgres_dump $*
        ;;

        info)
            postgres_info
        ;;

        import)
            shift 1
            postgres_import $*
        ;;

        connect)
            shift 1
            postgres_connect $*
        ;;

        ssh)
            shift 1
            postgres_connect_ssh $*
        ;;

        -h | --help)
            postgres_help_usage
        ;;

        *)            
            postgres_help_usage
        ;;
    esac
}
