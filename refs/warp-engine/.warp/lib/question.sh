#!/bin/bash

##
# Perform a question and grab the user answer 
# Use:
#    warp_banner
#
# Globals:
#   WARP_VERSION
#   WARP_COMMIT
# Arguments:
#   None
# Returns:
#   None
##
function warp_question_ask() {
    read -p "$1" response

    echo $response
}


function warp_question_ask_default() {

    if [ "$2" = "" ]; then
        echo "Error Default value is missing"
        exit;
    fi;

    read -p "$1" response

    if [ "$response" = "" ]; then
        echo "$2"
    else
        echo $response
    fi;
}
