#!/bin/bash +x

warp_message ""
warp_message_info "Configuring Mailhog SMTP server"

while : ; do
    respuesta_mailhog=$( warp_question_ask_default "Do you want to add Mailhog server? $(warp_message_info [Y/n]) " "Y" )

    if [ "$respuesta_mailhog" = "Y" ] || [ "$respuesta_mailhog" = "y" ] || [ "$respuesta_mailhog" = "N" ] || [ "$respuesta_mailhog" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_mailhog" = "Y" ] || [ "$respuesta_mailhog" = "y" ]
then

    while : ; do
        mailhog_binded_port=$( warp_question_ask_default "Plase select the port of your machine (host) to Web interface to view the messages: $(warp_message_info [8025]) " "8025" )

        if ! warp_net_port_in_use $mailhog_binded_port ; then
            warp_message_info2 "the selected port is: $mailhog_binded_port, Web interface to view the messages: $(warp_message_bold 'http://127.0.0.1:'$mailhog_binded_port)"
            break
        else
            warp_message_warn "The port $mailhog_binded_port is busy, choose another one\n"
        fi;
    done

    cat $PROJECTPATH/.warp/setup/mailhog/tpl/mailhog.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "#Config Mailhog" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MAILHOG_BINDED_PORT=$mailhog_binded_port"  >> $ENVIRONMENTVARIABLESFILESAMPLE

    echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE

    warp_message ""
fi; 
