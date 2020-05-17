#!/bin/bash

function fix_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp fix [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --php              $(warp_message 'fix permissions with php')"
    warp_message_info   " --mysql            $(warp_message 'fix permissions with mysql')"
    warp_message_info   " --grunt            $(warp_message 'fix permissions grunt')"
    warp_message_info   " --elasticsearch    $(warp_message 'fix permissions with elasticsearch')"
    warp_message_info   " --composer         $(warp_message 'fix permissions chmod() composer')"
    warp_message_info   " --addUser          $(warp_message 'add user docker and www-data to current user')"
    warp_message_info   " --owner            $(warp_message 'fix owner and read/write permissions inside the container')"
    warp_message_info   " --fast             $(warp_message 'add group www-data && ug+rw permissions inside the container')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " fixed problems with permissons inside the container"
    warp_message " add group www-data to files and folders"
    warp_message " add current owner to files and folders"
    warp_message " add user docker and www-data to current user"

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp fix"
    warp_message " warp fix --addUser"

    warp_message ""

}

function fix_help()
{
    warp_message_info   " fix                $(warp_message 'fix common problems with permissions')"
}
