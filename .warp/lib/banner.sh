#!/bin/bash

##
# Print the WARP banner
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
function warp_banner()
{
    warp_message ""
    warp_message "$FCYN  ___ ____     ____        _____ $RS"
    warp_message "$FCYN ____      ___      ______      ___ $RS"
    warp_message "$FCYN      _  ___  __    ___        ____ $RS"
    warp_message "$FCYN ___ | |     / /___ __________       ____ $RS"
    warp_message "$FCYN     | | /| / / __ \`/ ___/ __ \\ __    ___ $RS"
    warp_message "$FCYN ___ | |/ |/ / /_/ / /  / /_/ / __  ___ $RS"
    warp_message "$FCYN _   |__/|__/\__,_/_/  / .___/    ___   ____ $RS"
    warp_message "$FCYN  __   ___    ____    /_/  ___   __   __  $RS"
    warp_message "$FCYN      ____     ___   ____  __   ______ $RS"
    warp_message "$FCYN ____      ___      ______    ____   ____  $RS"
    warp_message ""
    warp_message "$FCYN WARP ENGINE\e[0m - Speeding up! your development infraestructure"
    warp_message "Version: $WARP_VERSION"
    warp_message "Commit version: $WARP_COMMIT"
    warp_message ""
}