#!/bin/bash

function elasticsearch_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp elasticsearch [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " elasticsearch service uses ports 9200 and 9300 inside the containers"
    warp_message " to use this service you must modify localhost:9200 by elasticsearch:9200 in the project"
    warp_message ""

}

function elasticsearch_help()
{
    warp_message_info   " elasticsearch      $(warp_message 'service of elasticsearch')"
}
