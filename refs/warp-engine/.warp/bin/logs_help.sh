#!/bin/bash

function logs_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp logs [options] [service_name]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " allows to see containers logs in each service, for example php, redis, elasticsearch, web, mysql  "
    warp_message " if not specify any service shows all containers logs"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp logs"
    warp_message " warp logs php"
    warp_message " warp logs mysql"
    warp_message " warp logs redis"
    warp_message ""    
}

function logs_help()
{
    warp_message_info   " logs               $(warp_message 'view logs containers')"
}
