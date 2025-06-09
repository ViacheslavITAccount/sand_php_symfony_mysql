FROM php:8.3-fpm-alpine

COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

RUN apk add --update --no-cache \
    libzip-dev \
    libpng \
    zip \
    bash \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli

RUN apk add --no-cache --virtual .build-deps \
    autoconf \
    linux-headers \
    make \
    g++ \
    && pecl install xdebug-3.3.2 \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && sed -i 's/^zend_extension=/;zend_extension=/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && apk del -f .build-deps

WORKDIR /var/www/project/

CMD ["php-fpm"]
