#!/bin/bash +x

if ! warp_check_env_file ; then
    warp_message_error "file not found $(basename $ENVIRONMENTVARIABLESFILE)"
    exit
fi; 

if [ $(warp_check_is_running) = false ]; then
    warp_message "starting containers, please wait"
    warp sandbox start
    sleep 6
fi

#echo "Create Project"
#docker run --rm -ti  -v $(pwd):/app -w /app summasolutions/php:7.1-fpm composer create-project --no-install --ignore-platform-reqs --repository=https://repo.magento.com/ magento/project-enterprise-edition:2.3.2
#docker run --rm -ti  -v $(pwd):/app -w /app summasolutions/php:7.1-fpm composer create-project --no-install --ignore-platform-reqs --repository=https://repo.magento.com/ magento/project-community-edition:2.3.2
#docker run --rm -ti  -v ~/.composer:/root/.composer -v $(pwd):/app -w /app summasolutions/php:7.1-fpm composer create-project --no-install --ignore-platform-reqs --repository=https://repo.magento.com/ magento/project-community-edition:2.3.2

ADMIN_USER="admin"
ADMIN_PASS="Password123"

DATABASE_ROOT_PASSWORD=$(warp_env_read_var DATABASE_ROOT_PASSWORD)

VIRTUAL_HOST_M22_CE=$(warp_env_read_var VIRTUAL_HOST_M22_CE)
VIRTUAL_HOST_M23_CE=$(warp_env_read_var VIRTUAL_HOST_M23_CE)

warp_message "Creating databases..."
docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "mysql -uroot -p$DATABASE_ROOT_PASSWORD -e \"CREATE DATABASE IF NOT EXISTS $DB_M22_CE;\"" > /dev/null
docker-compose -f $DOCKERCOMPOSEFILE exec mysql bash -c "mysql -uroot -p$DATABASE_ROOT_PASSWORD -e \"CREATE DATABASE IF NOT EXISTS $DB_M23_CE;\"" > /dev/null

#leave parameters
shift

warp_message "Install Magento 2.2.9 CE"
docker-compose -f $DOCKERCOMPOSEFILE exec php71 bash -c "cd /var/www/html/2.2.9-ce/ && \
    bin/magento setup:install \
        --backend-frontname=admin \
        --db-host=mysql \
        --db-name=$DB_M22_CE \
        --db-user=root \
        --db-password=$DATABASE_ROOT_PASSWORD \
        --base-url=https://$VIRTUAL_HOST_M22_CE/ \
        --admin-firstname=Admin \
        --admin-lastname=Admin \
        --admin-email=admin@admin.com \
        --admin-user=$ADMIN_USER \
        --admin-password=$ADMIN_PASS \
        --language=es_AR \
        --currency=ARS \
        --timezone=America/Argentina/Buenos_Aires \
        --use-rewrites=1"

warp_message "Install Magento 2.3.1 CE"
docker-compose -f $DOCKERCOMPOSEFILE exec php72 bash -c "cd /var/www/html/2.3.1-ce/ && \
    bin/magento setup:install \
        --backend-frontname=admin \
        --db-host=mysql \
        --db-name=$DB_M23_CE \
        --db-user=root \
        --db-password=$DATABASE_ROOT_PASSWORD \
        --base-url=https://$VIRTUAL_HOST_M23_CE/ \
        --admin-firstname=Admin \
        --admin-lastname=Admin \
        --admin-email=admin@admin.com \
        --admin-user=$ADMIN_USER \
        --admin-password=$ADMIN_PASS \
        --language=es_AR \
        --currency=ARS \
        --timezone=America/Argentina/Buenos_Aires \
        --use-rewrites=1"

warp_message "Turning on developer mode.."
docker-compose -f $DOCKERCOMPOSEFILE exec php71 bash -c "cd /var/www/html/2.2.9-ce/ && bin/magento deploy:mode:set developer"
docker-compose -f $DOCKERCOMPOSEFILE exec php72 bash -c "cd /var/www/html/2.3.1-ce/ && bin/magento deploy:mode:set developer"

warp_message "Copying files from container to host after install..."
warp sandbox pull --all

warp_message "Restarting containers with host bind mounts for dev..."
warp sandbox restart

warp_message "Docker development environment setup complete."
warp_message "You may now access your Magento instance at https://${VIRTUAL_HOST_M22_CE}/"
warp_message "You may now access your Magento instance at https://${VIRTUAL_HOST_M23_CE}/"
warp_message "Admin user: $ADMIN_USER"
warp_message "Admin pass: $ADMIN_PASS"
