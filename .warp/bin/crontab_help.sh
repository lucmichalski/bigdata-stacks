#!/bin/bash

function crontab_help_usage() 
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp crontab [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -e                 $(warp_message 'to create or edit a crontab')"
    warp_message_info   " -l                 $(warp_message 'to list a crontab')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " allows create and edit crontab inside the container"

    warp_message ""
    warp_message_info "Example:"
    warp_message " warp crontab -e"
    warp_message " warp crontab -l"

}

function crontab_help()
{
    warp_message_info   " crontab            $(warp_message 'work with crontab inside the containers')"
}
