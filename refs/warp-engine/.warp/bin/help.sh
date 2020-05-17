#!/bin/bash

function help_main() {

    warp_message_info "Utility for controlling dockerized projects\n"

    warp_message_info "Usage:"
    warp_message      " command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info ""
}

function help_usage() {

    warp_message ""
    warp_message_info "Help:"
    warp_message " warp mysql --help"
    warp_message ""    

}
