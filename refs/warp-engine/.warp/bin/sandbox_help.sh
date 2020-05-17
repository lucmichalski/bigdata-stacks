#!/bin/bash

function sandbox_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sandbox command [options] [arguments]"
    warp_message      " shortcut: warp sb command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --install          $(warp_message 'Install Magento')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " pull               $(warp_message 'pull folders/files from container to host')"
    warp_message_info   " push               $(warp_message 'push folders/files from host to container')"
    warp_message_info   " ssh                $(warp_message 'inside to container php')"
    warp_message_info   " start              $(warp_message 'start mode sandbox')"
    warp_message_info   " stop               $(warp_message 'stop mode sandbox')"
    warp_message_info   " restart            $(warp_message 'stop and start mode sandbox')"
    warp_message_info   " remove             $(warp_message 'unistall mode sandbox')"
    warp_message_info   " init               $(warp_message 'init mode sandbox TL/Dev')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " warp sandbox ssh --help"
    warp_message " warp sb ssh --help"

    warp_message ""

}

function sandbox_stop_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sandbox stop [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --hard             $(warp_message 'delete the container after stopping them')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " this command is used to stop the services"
    warp_message ""
}

function sandbox_ssh_help()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sandbox ssh [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --root             $(warp_message 'inside container php as root')"
    warp_message_info   " php                $(warp_message 'inside container php 7.0-fpm')"
    warp_message_info   " php71              $(warp_message 'inside container php 7.1-fpm')"
    warp_message_info   " php72              $(warp_message 'inside container php 7.2-fpm')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to php by ssh "
    warp_message " default user to connect is www-data "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp sandbox ssh"
    warp_message " warp sandbox ssh php71"
    warp_message " warp sandbox ssh --root"
    warp_message ""    

}

function sandbox_remove_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sandbox remove [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Unistall files and volumes on mode sandbox "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp sandbox remove"
    warp_message ""        
}

function sandbox_help()
{
    warp_message_info   " sandbox            $(warp_message 'mode sandbox for testing modules')"
}