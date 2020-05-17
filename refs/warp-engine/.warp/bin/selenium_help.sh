#!/bin/bash

function selenium_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp selenium command [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " start              $(warp_message 'start container with selenium service')"
    warp_message_info   " stop               $(warp_message 'stop container')"
    warp_message_info   " ssh                $(warp_message 'connect to selenium by ssh')"
    warp_message_info   " info               $(warp_message 'display info about services')"
    warp_message_info   " setup              $(warp_message 'instal selenium service')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " Selenium service with driver for Chrome and Firefox "
    warp_message " You can view path mapped to selenium files, please run: warp selenium info "

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp selenium start"
    warp_message " warp selenium stop"
    warp_message " warp selenium ssh"

    warp_message ""

}

function selenium_start_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp selenium start [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " this command is used for start selenium service"
    warp_message ""
}

function selenium_stop_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp selenium stop [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " this command is used for stop selenium service"
    warp_message ""
}

function selenium_ssh_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp selenium ssh [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Connect to selenium by ssh "
    warp_message " selenium has drivers for chrome and firefox, also map files from host to container "
    warp_message " for more info please run: warp selenium info "
    warp_message " for exit of container please run: exit "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp selenium ssh"
    warp_message ""    
}

function selenium_setup_help()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp selenium setup [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " this command creates necessary files to start the selenium container "
    warp_message ""
}

function selenium_help()
{
    warp_message_info   " selenium           $(warp_message 'service of selenium')"
}
