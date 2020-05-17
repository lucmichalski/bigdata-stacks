warp_message "* Configuring Network services in containers $(warp_message_ok [ok])"
sleep 1

    cat $PROJECTPATH/.warp/setup/networks/tpl/networks.yml >> $DOCKERCOMPOSEFILESAMPLE
    [ ! -f $DOCKERCOMPOSEFILE ] && cp $DOCKERCOMPOSEFILESAMPLE $DOCKERCOMPOSEFILE

    # LOAD VARIABLES SAMPLE
    . $ENVIRONMENTVARIABLESFILESAMPLE

    if [ ! $HTTP_HOST_IP = "0.0.0.0" ] ; then

        A="$(echo $HTTP_HOST_IP | cut -f1 -d . )"
        B="$(echo $HTTP_HOST_IP | cut -f2 -d . )"
        C="$(echo $HTTP_HOST_IP | cut -f3 -d . )"
        
        echo "# Network information" >> $ENVIRONMENTVARIABLESFILESAMPLE
        echo "NETWORK_SUBNET=$A.$B.$C.0/24" >> $ENVIRONMENTVARIABLESFILESAMPLE
        echo "NETWORK_GATEWAY=$A.$B.$C.1" >> $ENVIRONMENTVARIABLESFILESAMPLE
        echo "NETWORK_NAME=$NETWORK_NAME" >> $ENVIRONMENTVARIABLESFILESAMPLE

        if [ ! -z "$USE_VARNISH" ] ; then
            if [ "$USE_VARNISH" = "Y" ] || [ "$USE_VARNISH" = "y" ] ; then
                warp_network_varnish_multi_yes
            else
                #warp_network_varnish_multi_no
                warp_network_multi
            fi
        else
            warp_network_multi
        fi
    else

        echo "# Network information" >> $ENVIRONMENTVARIABLESFILESAMPLE
        echo "NETWORK_SUBNET=0.0.0.0/24" >> $ENVIRONMENTVARIABLESFILESAMPLE
        echo "NETWORK_GATEWAY=0.0.0.0" >> $ENVIRONMENTVARIABLESFILESAMPLE
        echo "NETWORK_NAME=$NETWORK_NAME" >> $ENVIRONMENTVARIABLESFILESAMPLE

        if [ ! -z "$USE_VARNISH" ] ; then
            if [ "$USE_VARNISH" = "Y" ] || [ "$USE_VARNISH" = "y" ] ; then
                warp_network_varnish_mono_yes
            else
                #warp_network_varnish_mono_no
                warp_network_mono
            fi
        else
            warp_network_mono
        fi
    fi    

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE