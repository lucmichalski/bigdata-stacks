#!/bin/bash

function xdebug_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp xdebug [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --enable           $(warp_message 'enable xdebug')"
    warp_message_info   " --disable          $(warp_message 'disable xdebug')"
    warp_message_info   " --status           $(warp_message 'display status of xdebug')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " enable, disable or display status of xdebug "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp xdebug --status"
    warp_message ""    
}

function xdebug_help()
{
    warp_message_info   " xdebug             $(warp_message 'enable/disable xdebug')"
}
