#!/bin/bash

function webserver_info()
{

    NGINX_CONFIG_FILE=$(warp_env_read_var NGINX_CONFIG_FILE)
    HTTP_BINDED_PORT=$(warp_env_read_var HTTP_BINDED_PORT)
    HTTPS_BINDED_PORT=$(warp_env_read_var HTTPS_BINDED_PORT)
    HTTP_HOST_IP=$(warp_env_read_var HTTP_HOST_IP)
    VIRTUAL_HOST=$(warp_env_read_var VIRTUAL_HOST)
    NGINX_CONFIG_FILE=$(warp_env_read_var NGINX_CONFIG_FILE)

    if [ ! -z "$NGINX_CONFIG_FILE" ]
    then
        warp_message ""
        warp_message_info "* Webserver"
        warp_message "Virtual host:               $(warp_message_info $VIRTUAL_HOST)"
    

        ETC_HOSTS_IP='127.0.0.1'
        if [ "$HTTP_HOST_IP" = "0.0.0.0" ] ; then
            warp_message "Server IP:                  $(warp_message_info '127.0.0.1')"
            warp_message "HTTP binded port (host):    $(warp_message_info $HTTP_BINDED_PORT)"
            warp_message "HTTPS binded port (host):   $(warp_message_info $HTTPS_BINDED_PORT)"
        else
            warp_message "Server IP:                  $(warp_message_info $HTTP_HOST_IP)"
            ETC_HOSTS_IP=$HTTP_HOST_IP
        fi;
        warp_message "Logs:                       $(warp_message_info $PROJECTPATH/.warp/docker/volumes/nginx/logs)" 
        warp_message "Nginx configuration file:   $(warp_message_info $NGINX_CONFIG_FILE)" 
        warp_message ""
        warp_message_warn " - Configure your hosts file (/etc/hosts) with: $(warp_message_bold $ETC_HOSTS_IP'  '$VIRTUAL_HOST)"
        warp_message ""
    fi
}

function webserver_main()
{
    case "$1" in
 
        info)
            webserver_info
        ;;

        -h | --help)
            webserver_info
        ;;

        *)            
            webserver_info
        ;;
    esac    
}
