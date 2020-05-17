FROM magento/magento-cloud-docker-php:7.2-cli-1.1

LABEL maintainer="Matias Anoniz <matiasanoniz@gmail.com>"

ENV MAGENTO_VERSION 2.3.4
ENV INSTALL_DIR /var/www/html/${MAGENTO_VERSION}-ee

RUN mkdir -p $INSTALL_DIR

RUN curl -L -o /tmp/$MAGENTO_VERSION.zip https://github.com/magento/magento-cloud/archive/$MAGENTO_VERSION.zip \ 
    && unzip -o /tmp/$MAGENTO_VERSION.zip -d /tmp/$MAGENTO_VERSION \
    && mv /tmp/$MAGENTO_VERSION/magento-cloud-$MAGENTO_VERSION/* $INSTALL_DIR

COPY auth.json $INSTALL_DIR

RUN cd $INSTALL_DIR \
    && composer install --ignore-platform-reqs --classmap-authoritative --no-interaction \
    && find . -type d -exec chmod 770 {} \; \
    && find . -type f -exec chmod 660 {} \; \
    && [ -f $INSTALL_DIR/bin/magento ] && chmod +x $INSTALL_DIR/bin/magento

RUN rm $INSTALL_DIR/auth.json

RUN chown -R www-data:www-data /var/www

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $INSTALL_DIR

# https://github.com/magento/magento-cloud
# https://github.com/magento/magento-cloud-docker
# warp build --no-cache --tag summasolutions/magento:2.3.4-ee images/magento2/2.3.4-ee
