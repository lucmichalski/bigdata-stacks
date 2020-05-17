#!/bin/bash

function composer_help_usage() 
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp composer [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -T                 $(warp_message 'Disable pseudo TTY. Useful for Jenkins integration')"
    warp_message_info   " --credential       $(warp_message 'copy credential ID_RSA inside the container ')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " allows to run composer inside the container"

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp composer install"
    warp_message " warp composer --credential"
    warp_message " warp composer --credential /path/to/id_custom"

}

function composer_help()
{
    warp_message_info   " composer           $(warp_message 'execute composer inside container')"
}
