#!/bin/bash +x

warp_message ""
warp_message_info "Configuring the MySQL Service"

while : ; do
    respuesta_mysql=$( warp_question_ask_default "Do you want to add a MySQL service? $(warp_message_info [Y/n]) " "Y" )

    if [ "$respuesta_mysql" = "Y" ] || [ "$respuesta_mysql" = "y" ] || [ "$respuesta_mysql" = "N" ] || [ "$respuesta_mysql" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_mysql" = "Y" ] || [ "$respuesta_mysql" = "y" ]
then

    warp_message_info2 "You can check the available versions of MySQL here: $(warp_message_info '[ https://hub.docker.com/r/library/mysql/tags/ ]')"
    mysql_version=$( warp_question_ask_default "Choose the MySQL engine version: $(warp_message_info [5.7]) " "5.7" )
    warp_message_info2 "Selected MySQL Version: $mysql_version"

    mysql_docker_image="mysql:${mysql_version}"

    if [ "$private_registry_mode" = "Y" ] || [ "$private_registry_mode" = "y" ] ; then
        # while : ; do
        #     mysql_use_project_specific=$( warp_question_ask_default "Do you want to use a custom specific DB image from your private registry? $(warp_message_info [Y/n]) " "Y" )

        #     if [ "$mysql_use_project_specific" = "Y" ] || [ "$mysql_use_project_specific" = "y" ] || [ "$mysql_use_project_specific" = "N" ] || [ "$mysql_use_project_specific" = "n" ] ; then
        #         break
        #     else
        #         warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
        #     fi
        # done;
        
        if [ ! -z "$docker_private_registry" ]
        then
            # Overwrite default mysql image.
            mysql_docker_image="${namespace_name}-${project_name}-dbs"    
            mysql_use_project_specific=Y
        fi    
    fi

    while : ; do
        mysql_name_database=$( warp_question_ask_default "Set the database name: $(warp_message_info [warp_db]) " "warp_db" )

        if [ ! $mysql_name_database = 'root' ] ; then
            warp_message_info2 "Database created: $mysql_name_database"
            break
        else 
            warp_message_warn "The database name can not be $(warp_message_bold root)"
        fi;
    done

    while : ; do
        mysql_user_database=$( warp_question_ask_default "Add the database user: $(warp_message_info [warp]) " "warp" )
        
        if [ ! $mysql_user_database = 'root' ] ; then
            warp_message_info2 "The database user is: $mysql_user_database"
            break
        else 
            warp_message_warn "The database user can not be $(warp_message_bold root)"
        fi;
    done

    while : ; do
        mysql_password_database=$( warp_question_ask_default "Choose the database password: $(warp_message_info [Warp2020]) " "Warp2020" )
        
        if [ ! $mysql_password_database = 'root' ] ; then
            warp_message_info2 "The database password is: $mysql_password_database"
            break
        else 
            warp_message_warn "The password can not be $(warp_message_bold root)"
        fi;
    done

    while : ; do
        mysql_binded_port=$( warp_question_ask_default "Mapping container port 3306 to your machine port (host): $(warp_message_info [3306]) " "3306" )

        #CHECK si port es numero antes de llamar a warp_net_port_in_use
        if ! warp_net_port_in_use $mysql_binded_port ; then
            warp_message_info2 "the selected port is: $mysql_binded_port, the port mapping is: $(warp_message_bold '127.0.0.1:'$mysql_binded_port' ---> container_host:3306')"
            break
        else
            warp_message_warn "The port $mysql_binded_port is busy, choose another one\n"
        fi;
    done

    # Default Random password for user root
    default_mysql_root_password=$(warp_env_random_password $STRONG_PASSWORD_LENGTH)

    mysql_root_password=$( warp_question_ask_default "Set the MySQL main password (root user)? $(warp_message_info [$default_mysql_root_password]) " "$default_mysql_root_password" )
    warp_message_info2 "Root user password: $mysql_root_password"
    mysql_config_file=$( warp_question_ask_default "Add the MySQL configuration file: $(warp_message_info [./.warp/docker/config/mysql/conf.d]) " "./.warp/docker/config/mysql/conf.d" )
    warp_message_info2 "Selected configuration file: $mysql_config_file"

    if [ "$mysql_use_project_specific" = "Y" ] || [ "$mysql_use_project_specific" = "y" ]; then
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database_custom.yml >> $DOCKERCOMPOSEFILESAMPLE
    else
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database.yml >> $DOCKERCOMPOSEFILESAMPLE
    fi
    
    cat $PROJECTPATH/.warp/setup/mysql/tpl/database_enviroment_root.yml >> $DOCKERCOMPOSEFILESAMPLE

    echo "# MySQL Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_VERSION=$mysql_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_DOCKER_IMAGE=$mysql_docker_image" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "MYSQL_CONFIG_FILE=$mysql_config_file" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_BINDED_PORT=$mysql_binded_port" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_ROOT_PASSWORD=$mysql_root_password" >> $ENVIRONMENTVARIABLESFILESAMPLE

    cat $PROJECTPATH/.warp/setup/mysql/tpl/database_enviroment_default.yml >> $DOCKERCOMPOSEFILESAMPLE
    echo "DATABASE_NAME=$mysql_name_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_USER=$mysql_user_database" >> $ENVIRONMENTVARIABLESFILESAMPLE
    echo "DATABASE_PASSWORD=$mysql_password_database" >> $ENVIRONMENTVARIABLESFILESAMPLE

    if [ "$mysql_use_project_specific" = "Y" ] || [ "$mysql_use_project_specific" = "y" ]; then
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database_volumes_networks_custom.yml >> $DOCKERCOMPOSEFILESAMPLE
    else
        cat $PROJECTPATH/.warp/setup/mysql/tpl/database_volumes_networks.yml >> $DOCKERCOMPOSEFILESAMPLE
    fi
    

    cp -R $PROJECTPATH/.warp/setup/mysql/config/ $PROJECTPATH/.warp/docker/config/mysql/
fi; 

