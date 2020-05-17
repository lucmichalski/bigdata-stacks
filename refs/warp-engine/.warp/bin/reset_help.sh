#!/bin/bash

function reset_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp reset [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --hard             $(warp_message 'remove all configurations')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " remove configurations for mysql and nginx, so you can reconfigure them"
    warp_message " if usage flag --hard delete all the settings and you must reconfigure the project"
    warp_message " warp reset --help"

    warp_message ""
}

function reset_help()
{
    warp_message_info   " reset              $(warp_message 'Reset current Projects to default')"
}
