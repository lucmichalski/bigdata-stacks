#!/bin/bash

function volume_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp volume [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --rm               $(warp_message 'remove volume by container name')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " to remove volume data it's necessary"
    warp_message " than containers are not running,"
    warp_message " before executing this command must be executed \"warp stop --hard\""
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp volume --rm php"
    warp_message " warp volume --rm mysql"
    warp_message ""    
}

function volume_help()
{
    warp_message_info   " volume             $(warp_message 'manage docker volumes')"
}
