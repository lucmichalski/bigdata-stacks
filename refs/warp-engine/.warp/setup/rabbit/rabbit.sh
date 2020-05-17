#!/bin/bash +x

warp_message ""
warp_message_info "Configuring Rabbit Service"

while : ; do
    respuesta_rabbit=$( warp_question_ask_default "Do you want to add a service for Rabbit? $(warp_message_info [y/N]) " "N" )

    if [ "$respuesta_rabbit" = "Y" ] || [ "$respuesta_rabbit" = "y" ] || [ "$respuesta_rabbit" = "N" ] || [ "$respuesta_rabbit" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_rabbit" = "Y" ] || [ "$respuesta_rabbit" = "y" ]
then

    warp_message_info2 "You can check the Rabbit versions available here: $(warp_message_info '[ https://hub.docker.com/r/summasolutions/rabbitmq/tags ]')"
  
    resp_version_rabbit=$( warp_question_ask_default "What version of Rabbit do you want to use? $(warp_message_info [3.7-management]) " "3.7-management" )
    warp_message_info2 "Selected Rabbit version: $resp_version_rabbit, in the internal port 5672 $(warp_message_bold 'rabbitmq:5672')"

    while : ; do
        rabbit_binded_port=$( warp_question_ask_default "Mapping container port 15672 to your machine port (host): $(warp_message_info [8081]) " "8081" )

        if ! warp_net_port_in_use $rabbit_binded_port ; then
            warp_message_info2 "the selected port is: $rabbit_binded_port, the port mapping is: $(warp_message_bold '127.0.0.1:'$rabbit_binded_port' ---> container_host:15672')"
            break
        else
            warp_message_warn "The port $rabbit_binded_port is busy, choose another one\n"
        fi;
    done

    rabbit_default_user=$( warp_question_ask_default "Choose the default user: $(warp_message_info [guest]) " "guest" )
    warp_message_info2 "Selected Rabbit User: $rabbit_default_user"

    rabbit_default_password=$( warp_question_ask_default "Choose the default password: $(warp_message_info [guest]) " "guest" )
    warp_message_info2 "Selected Rabbit Password: $rabbit_default_password"

#   rabbit_config_file=$( warp_question_ask_default "Add the Rabbit configuration file: $(warp_message_info [./.warp/docker/config/etc/rabbitmq/]) " "./.warp/docker/config/etc/rabbitmq" )
#   warp_message_info2 "Selected configuration file: $rabbit_config_file"


    cat $PROJECTPATH/.warp/setup/rabbit/tpl/rabbit.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "#Config Rabbit" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBIT_VERSION=$resp_version_rabbit" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBIT_BINDED_PORT=$rabbit_binded_port"  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBITMQ_DEFAULT_USER=$rabbit_default_user" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "RABBITMQ_DEFAULT_PASS=$rabbit_default_password"  >> $ENVIRONMENTVARIABLESFILESAMPLE

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    warp_message ""
fi; 
