#!/bin/bash

function start_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp start [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " -f                 $(warp_message 'attach and add custom yml file')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " this command is used to start the services"
    warp_message " if you started with flag -f to use a custom yml file, check beforehand if the file exists"
    warp_message ""

}

function start_help()
{
    warp_message_info   " start              $(warp_message 'start the server and all of its components')"
}