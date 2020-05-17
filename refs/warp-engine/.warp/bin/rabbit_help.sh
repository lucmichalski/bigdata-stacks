#!/bin/bash

function rabbit_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp rabbit command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " info               $(warp_message 'display info available')"


    warp_message ""
    warp_message_info "Help:"
    warp_message " rabbitmq service used in ports 5672 inside containers"
    warp_message " for more information about rabbit you can access the following link: https://www.rabbitmq.com/"

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp rabbit --help"
    warp_message ""    

}

function rabbit_help()
{
    warp_message_info   " rabbit             $(warp_message 'service of rabbit')"
}
