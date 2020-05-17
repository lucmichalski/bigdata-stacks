#!/bin/bash

function stop_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp stop [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " --hard             $(warp_message 'delete the container after stopping them')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " this command is used to stop the services"
    warp_message ""
}

function stop_help()
{
    warp_message_info   " stop               $(warp_message 'stop the server and all of its components')"
}