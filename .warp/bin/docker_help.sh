#!/bin/bash

function docker_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp docker [options] [command]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " allows run docker-compose commands"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp docker ps"
    warp_message " warp docker down"
    warp_message ""    
}

function docker_help()
{
    warp_message_info   " docker             $(warp_message 'allows run docker-compose commands')"
}
