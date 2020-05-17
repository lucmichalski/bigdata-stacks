#!/bin/bash

function info_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp info [options] [service_name]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --ip               $(warp_message 'display ip and name of each container')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Shows the configured values and useful information for each services, for example php, redis, elasticsearch, web, mysql"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp info"
    warp_message " warp info --ip"
    warp_message ""    
}

function info_help()
{
    warp_message_info   " info               $(warp_message 'Shows the configured values and useful information for each services')"
}
