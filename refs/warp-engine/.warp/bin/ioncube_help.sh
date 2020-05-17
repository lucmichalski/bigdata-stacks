#!/bin/bash

function ioncube_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp ioncube [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --enable           $(warp_message 'enable ioncube')"
    warp_message_info   " --disable          $(warp_message 'disable ioncube')"
    warp_message_info   " --status           $(warp_message 'display status of ioncube')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " enable, disable or display status of ioncube "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp ioncube --status"
    warp_message ""    
}

function ioncube_help()
{
    warp_message_info   " ioncube            $(warp_message 'enable/disable ioncube')"
}
