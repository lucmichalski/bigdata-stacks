#!/bin/bash +x

# INIT PROJECTS MODE NO-INTERACTIONS WITHOUT WIZARD

[ ! -f $ENVIRONMENTVARIABLESFILE ] && cp $ENVIRONMENTVARIABLESFILESAMPLE $ENVIRONMENTVARIABLESFILE
[ ! -f $DOCKERCOMPOSEFILE ] && cp $DOCKERCOMPOSEFILESAMPLE $DOCKERCOMPOSEFILE

    # LOAD VARIABLES SAMPLE
    . $ENVIRONMENTVARIABLESFILESAMPLE

case "$(uname -s)" in
    Darwin)

    warp_message ""
    warp_message "* Configuring mapping files to container $(warp_message_ok [ok])"

        rta_use_docker_sync="N"

        # Get sample from template
        if [ "$rta_use_docker_sync" = "Y" ] || [ "$rta_use_docker_sync" = "y" ] ; then
            cat $PROJECTPATH/.warp/setup/mac/tpl/docker-compose-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
        else
            if [[ "$FRAMEWORK" = "oro" ]]
            then
                cat $PROJECTPATH/.warp/setup/mac/tpl/docker-mapping-oro-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
            else
                cat $PROJECTPATH/.warp/setup/mac/tpl/docker-mapping-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
            fi
        fi

        VOLUME_WARP_DEFAULT="warp-volume-sync"
        VOLUME_WARP="$(basename $(pwd))-volume-sync"

        cat $DOCKERCOMPOSEFILEMAC | sed -e "s/$VOLUME_WARP_DEFAULT/$VOLUME_WARP/" > "$DOCKERCOMPOSEFILEMAC.tmp"
        mv "$DOCKERCOMPOSEFILEMAC.tmp" $DOCKERCOMPOSEFILEMAC

        if [ ! -f $DOCKERSYNCMACSAMPLE ] 
        then
            cat $PROJECTPATH/.warp/setup/mac/tpl/docker-sync.yml > $DOCKERSYNCMACSAMPLE
        fi;
        
        cp $DOCKERSYNCMACSAMPLE $DOCKERSYNCMAC

        cat $DOCKERSYNCMAC | sed -e "s/$VOLUME_WARP_DEFAULT/$VOLUME_WARP/" > "$DOCKERSYNCMAC.tmp"
        mv "$DOCKERSYNCMAC.tmp" $DOCKERSYNCMAC
    ;;
esac

    warp_message "* Configuring Web Server - Nginx $(warp_message_ok [ok])"

    useproxy=1 #False

    http_port="80"
    https_port="443"

    if [ ! -z "$DATABASE_BINDED_PORT" ]
    then
        warp_message "* Configuring the MySQL Service $(warp_message_ok [ok])"

        mysql_binded_port="3306"
    fi

    if [ ! -z "$RABBIT_VERSION" ]
    then    
        warp_message "* Configuring the Rabbit Service $(warp_message_ok [ok])"

        rabbit_binded_port="8080"
    fi

    if [ ! -z "$MAILHOG_BINDED_PORT" ]
    then
    
        warp_message "* Configuring Mailhog SMTP server $(warp_message_ok [ok])"

        mailhog_binded_port="8025"
    fi

    HTTP_HOST_OLD="HTTP_HOST_IP=$HTTP_HOST_IP"
    HTTP_BINDED_OLD="HTTP_BINDED_PORT=$HTTP_BINDED_PORT"
    HTTPS_BINDED_OLD="HTTPS_BINDED_PORT=$HTTPS_BINDED_PORT"

    N1="$(echo $NETWORK_SUBNET | cut -f1 -d / )" 
    N2="$(echo $NETWORK_SUBNET | cut -f2 -d / )" 
    NETWORK_SUBNET_OLD="NETWORK_SUBNET=$N1\/$N2"
    NETWORK_GATEWAY_OLD="NETWORK_GATEWAY=$NETWORK_GATEWAY"

    if [ $useproxy = 0 ]; then
        # Cambia IP a multi-proyecto

        HTTP_HOST_NEW="HTTP_HOST_IP=$http_container_ip"
        HTTP_BINDED_NEW="HTTP_BINDED_PORT=80"
        HTTPS_BINDED_NEW="HTTPS_BINDED_PORT=443"

        # Modify Gateway and Subnet

        A="$(echo $http_container_ip | cut -f1 -d . )"
        B="$(echo $http_container_ip | cut -f2 -d . )"
        C="$(echo $http_container_ip | cut -f3 -d . )"
        
        NETWORK_SUBNET_NEW="NETWORK_SUBNET=$A.$B.$C.0\/24"
        NETWORK_GATEWAY_NEW="NETWORK_GATEWAY=$A.$B.$C.1"

        # Cambio yml a multi-proyecto
        warp_network_multi

    else
        # Cambia IP a mono-proyecto

        HTTP_HOST_NEW="HTTP_HOST_IP=0.0.0.0"
        HTTP_BINDED_NEW="HTTP_BINDED_PORT=$http_port"
        HTTPS_BINDED_NEW="HTTPS_BINDED_PORT=$https_port"

        NETWORK_SUBNET_NEW="NETWORK_SUBNET=0.0.0.0\/24"
        NETWORK_GATEWAY_NEW="NETWORK_GATEWAY=0.0.0.0"

        # Cambio yml a multi-proyecto
        warp_network_mono

    fi;

    # CHANGE IP AND PORT WEB
    cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$HTTP_HOST_OLD/$HTTP_HOST_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp1"
    mv "$ENVIRONMENTVARIABLESFILE.warp1" $ENVIRONMENTVARIABLESFILE

    cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$HTTP_BINDED_OLD/$HTTP_BINDED_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp2"
    mv "$ENVIRONMENTVARIABLESFILE.warp2" $ENVIRONMENTVARIABLESFILE

    cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$HTTPS_BINDED_OLD/$HTTPS_BINDED_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp3"
    mv "$ENVIRONMENTVARIABLESFILE.warp3" $ENVIRONMENTVARIABLESFILE

    cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$NETWORK_SUBNET_OLD/$NETWORK_SUBNET_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp4"
    mv "$ENVIRONMENTVARIABLESFILE.warp4" $ENVIRONMENTVARIABLESFILE

    cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$NETWORK_GATEWAY_OLD/$NETWORK_GATEWAY_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp5"
    mv "$ENVIRONMENTVARIABLESFILE.warp5" $ENVIRONMENTVARIABLESFILE

    if [ ! -z "$USE_VARNISH" ]
    then
        if [ "$USE_VARNISH" = "Y" ] || [ "$USE_VARNISH" = "y" ] ; then
            warp_message "* Configuring Varnish Service $(warp_message_ok [ok])"        

            respuesta_varnish="N"

            if [ "$respuesta_varnish" = "Y" ] || [ "$respuesta_varnish" = "y" ] ; then
                if [ $useproxy = 0 ]; then
                    warp_network_varnish_multi_yes
                else
                    warp_network_varnish_mono_yes
                fi
            else
                if [ $useproxy = 0 ]; then
                    warp_network_varnish_multi_no
                else
                    warp_network_varnish_mono_no
                fi
            fi
        fi
    fi

    if [ ! -z "$DATABASE_BINDED_PORT" ]
    then
        # CHANGE PORT MYSQL
        BINDED_PORT_OLD="DATABASE_BINDED_PORT=$DATABASE_BINDED_PORT"
        BINDED_PORT_NEW="DATABASE_BINDED_PORT=$mysql_binded_port"

        cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$BINDED_PORT_OLD/$BINDED_PORT_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp6"
        mv "$ENVIRONMENTVARIABLESFILE.warp6" $ENVIRONMENTVARIABLESFILE
    fi


    if [ ! -z "$RABBIT_VERSION" ]
    then
        # CHANGE PORT RABBIT
        BINDED_PORT_OLD="RABBIT_BINDED_PORT=$RABBIT_BINDED_PORT"
        BINDED_PORT_NEW="RABBIT_BINDED_PORT=$rabbit_binded_port"

        cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$BINDED_PORT_OLD/$BINDED_PORT_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp7"
        mv "$ENVIRONMENTVARIABLESFILE.warp7" $ENVIRONMENTVARIABLESFILE
    fi

    if [ ! -z "$MAILHOG_BINDED_PORT" ]
    then
        # CHANGE PORT MAILHOG
        BINDED_PORT_OLD="MAILHOG_BINDED_PORT=$MAILHOG_BINDED_PORT"
        BINDED_PORT_NEW="MAILHOG_BINDED_PORT=$mailhog_binded_port"

        cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$BINDED_PORT_OLD/$BINDED_PORT_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp8"
        mv "$ENVIRONMENTVARIABLESFILE.warp8" $ENVIRONMENTVARIABLESFILE
    fi

    if [ ! -z "$rta_use_docker_sync" ]
    then
        # SAVE OPTION SYNC
        USE_DOCKER_SYNC_OLD="USE_DOCKER_SYNC=$USE_DOCKER_SYNC"
        USE_DOCKER_SYNC_NEW="USE_DOCKER_SYNC=$rta_use_docker_sync"

        if [ -z "$USE_DOCKER_SYNC" ]
        then
            echo "" >> $ENVIRONMENTVARIABLESFILE
            echo "# Docker Sync" >> $ENVIRONMENTVARIABLESFILE
            echo "USE_DOCKER_SYNC=${rta_use_docker_sync}" >> $ENVIRONMENTVARIABLESFILE
            echo "" >> $ENVIRONMENTVARIABLESFILE
        else
            cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$USE_DOCKER_SYNC_OLD/$USE_DOCKER_SYNC_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp9"
            mv "$ENVIRONMENTVARIABLESFILE.warp9" $ENVIRONMENTVARIABLESFILE
        fi;
    fi

    if [ ! -z "$respuesta_varnish" ]
    then
        # SAVE OPTION VARNISH
        USE_VARNISH_OLD="USE_VARNISH=$USE_VARNISH"
        USE_VARNISH_NEW="USE_VARNISH=$respuesta_varnish"

        if [ -z "$USE_VARNISH" ]
        then
            echo "" >> $ENVIRONMENTVARIABLESFILE
            echo "# VARNISH Configuration" >> $ENVIRONMENTVARIABLESFILE
            echo "USE_VARNISH=$respuesta_varnish" >> $ENVIRONMENTVARIABLESFILE
            echo "" >> $ENVIRONMENTVARIABLESFILE    
        else
            cat $ENVIRONMENTVARIABLESFILE | sed -e "s/$USE_VARNISH_OLD/$USE_VARNISH_NEW/" > "$ENVIRONMENTVARIABLESFILE.warp10"
            mv "$ENVIRONMENTVARIABLESFILE.warp10" $ENVIRONMENTVARIABLESFILE
        fi;
    fi

    . "$WARPFOLDER/setup/init/info.sh"
