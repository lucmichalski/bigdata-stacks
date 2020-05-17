#!/bin/bash

function mysql_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp mysql command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " info               $(warp_message 'display info available')"
    warp_message_info   " dump               $(warp_message 'allows to make a database dump')"
    warp_message_info   " connect            $(warp_message 'connect to mysql command line (shell)')"
    warp_message_info   " import             $(warp_message 'allows to restore a database')"
    warp_message_info   " ssh                $(warp_message 'connect to mysql by ssh')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " warp mysql dump --help"

    warp_message ""

}

function mysql_import_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp mysql import [db_name] < [file]"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Allow to recover a database inside the container, indicating a path of your local machine"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp mysql import warp_db < /path/to/restore/backup/warp_db.sql"
    warp_message " gunzip < /path/to/restore/backup/warp_db.sql.gz | warp mysql import warp_db"
    warp_message " gunzip < /path/to/restore/backup/warp_db.sql.gz | pv | warp mysql import warp_db"

    warp_message ""

}

function mysql_dump_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp mysql dump [db_name] > [file]"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Create a backup of a database and save it local machine"
    warp_message " to remove all the security definers of a mysql dump, add this to the command: sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/'"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp mysql dump warp_db | gzip > /path/to/save/backup/warp_db.sql.gz"
    warp_message " warp mysql dump warp_db | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' | gzip > /path/to/save/backup/warp_db.sql.gz"
    warp_message " warp mysql dump warp_db | gzip | pv > /path/to/save/backup/warp_db.sql.gz"
    warp_message " warp mysql dump warp_db > /path/to/save/backup/warp_db.sql"
    warp_message ""

}

function mysql_connect_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp mysql connect"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to mysql command line "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp mysql connect"
    warp_message " mysql >> show databases;"
    warp_message ""
}

function mysql_ssh_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp mysql ssh"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to mysql by ssh "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp mysql ssh"
    warp_message ""
}

function mysql_help()
{
    warp_message_info   " mysql              $(warp_message 'utility for connect with mysql databases')"

}