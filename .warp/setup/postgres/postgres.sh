#!/bin/bash +x

warp_message ""
warp_message_info "Configuring PostgreSQL Service"

while : ; do
    respuesta_psql=$( warp_question_ask_default "Do you want to add a PostgreSQL service? $(warp_message_info [y/N]) " "N" )

    if [ "$respuesta_psql" = "Y" ] || [ "$respuesta_psql" = "y" ] || [ "$respuesta_psql" = "N" ] || [ "$respuesta_psql" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_psql" = "Y" ] || [ "$respuesta_psql" = "y" ]
then

    warp_message_info2 "You can check the available versions of PostgreSQL here: $(warp_message_info '[ https://hub.docker.com/r/summasolutions/postgres/tags/ ]')"
    while : ; do
        psql_version=$( warp_question_ask_default "Choose the PostgreSQL engine version: $(warp_message_info [9.6.15]) " "9.6.15" )
    
        case $psql_version in
        '9.6.15')
            break
        ;;
        *)
            warp_message_info2 "Selected: $psql_version, the available versions is 9.6.15"
        ;;
        esac        
    done

    warp_message_info2 "Selected PostgreSQL Version: $psql_version"

    while : ; do
        psql_name_database=$( warp_question_ask_default "Set the database name: $(warp_message_info [warp_db]) " "warp_db" )

        if [ ! $psql_name_database = 'root' ] ; then
            warp_message_info2 "Database created: $psql_name_database"
            break
        else 
            warp_message_warn "The database name can not be $(warp_message_bold root)"
        fi;
    done

    while : ; do
        psql_user_database=$( warp_question_ask_default "Add the database user: $(warp_message_info [warp]) " "warp" )
        
        if [ ! $psql_user_database = 'root' ] ; then
            warp_message_info2 "The database user is: $psql_user_database"
            break
        else 
            warp_message_warn "The database user can not be $(warp_message_bold root)"
        fi;
    done

    while : ; do
        psql_password_database=$( warp_question_ask_default "Choose the database password: $(warp_message_info [Warp2020]) " "Warp2020" )
        
        if [ ! $psql_password_database = 'root' ] ; then
            warp_message_info2 "The database password is: $psql_password_database"
            break
        else 
            warp_message_warn "The password can not be $(warp_message_bold root)"
        fi;
    done

    while : ; do
        psql_binded_port=$( warp_question_ask_default "Mapping container port 5432 to your machine port (host): $(warp_message_info [5432]) " "5432" )

        #CHECK si port es numero antes de llamar a warp_net_port_in_use
        if ! warp_net_port_in_use $psql_binded_port ; then
            warp_message_info2 "the selected port is: $psql_binded_port, the port mapping is: $(warp_message_bold '127.0.0.1:'$psql_binded_port' ---> container_host:5432')"
            break
        else
            warp_message_warn "The port $psql_binded_port is busy, choose another one\n"
        fi;
    done
    
    cat $PROJECTPATH/.warp/setup/postgres/tpl/postgres.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo ""  >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "# PostgreSQL Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_VERSION=$psql_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_BINDED_PORT=$psql_binded_port" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_DB=$psql_name_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_USER=$psql_user_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "POSTGRES_PASSWORD=$psql_password_database" >> $ENVIRONMENTVARIABLESFILESAMPLE    

fi; 

