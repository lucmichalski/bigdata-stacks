#!/bin/bash

function oro_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp oro [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " -T                 $(warp_message 'disable pseudo TTY. Useful for Jenkins integration')"
    warp_message_info   " --root             $(warp_message 'execute oro console with root privileges')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Allow run bin/console inside the container for v3"
    warp_message " Allow run app/console inside the container for v1.6"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp oro cache:clean"
    warp_message ""    
}

function oro_help()
{
    warp_message_info   " oro                $(warp_message 'execute oro console inside the container')"

}
