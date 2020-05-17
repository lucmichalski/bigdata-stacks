#!/bin/bash

function npm_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp npm [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Allow run npm inside the container "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp npm install"
    warp_message ""    
}

function npm_help()
{
    warp_message_info   " npm                $(warp_message 'execute npm inside the container')"
}
