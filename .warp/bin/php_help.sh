#!/bin/bash

function php_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp php command [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " ssh                $(warp_message 'connect to php by ssh')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to php by ssh "
    warp_message " default user to connect is www-data "
    warp_message " You can also see logs of php service with the command: warp logs php "

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp php ssh"
    warp_message " warp php ssh --root"
    warp_message " warp php ssh --help"

    warp_message ""

}

function php_ssh_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp php ssh [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --root             $(warp_message 'inside container php as root')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to php by ssh "
    warp_message " default user to connect is www-data "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp php ssh"
    warp_message " warp php ssh --root"
    warp_message ""    
}

function php_help()
{
    warp_message_info   " php                $(warp_message 'service of php')"
}
