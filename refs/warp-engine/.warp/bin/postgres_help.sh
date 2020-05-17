#!/bin/bash

function postgres_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp postgres command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " info               $(warp_message 'display info available')"
    warp_message_info   " dump               $(warp_message 'allows to make a database dump')"
    warp_message_info   " connect            $(warp_message 'connect to postgres command line (shell)')"
    warp_message_info   " import             $(warp_message 'allows to restore a database')"
    warp_message_info   " ssh                $(warp_message 'connect to postgres by ssh')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " warp postgres dump --help"

    warp_message ""

}

function postgres_import_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp postgres import [db_name] < [file]"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Allow to recover a database inside the container, indicating a path of your local machine"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp postgres import warp_db < /path/to/restore/backup/warp_db.pgsql"
    warp_message ""

}

function postgres_dump_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp postgres dump [db_name] > [file]"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Create a backup of a database and save it local machine"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp postgres dump warp_db | gzip > /path/to/save/backup/warp_db.pgsql.gz"
    warp_message " warp postgres dump warp_db > /path/to/save/backup/warp_db.pgsql"
    warp_message ""

}

function postgres_connect_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp postgres connect"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to postgres command line "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp postgres connect"
    warp_message " warp_db=# \l"
    warp_message ""
}

function postgres_ssh_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp postgres ssh"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to postgres by ssh "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp postgres ssh"
    warp_message ""
}

function postgres_help()
{
    warp_message_info   " postgres           $(warp_message 'utility for connect with postgres databases')"

}