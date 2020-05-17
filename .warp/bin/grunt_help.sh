#!/bin/bash

function grunt_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp grunt [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Allow run grunt inside the container "
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp grunt exec"
    warp_message " warp grunt less"
    warp_message ""    
}

function grunt_help()
{
    warp_message_info   " grunt              $(warp_message 'execute grunt inside the container')"
}
