FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

RUN apk add --no-cache \
    supervisor \
    nodejs \
    npm \
    zip \
    re2c \
    file \
    nginx \
    libpng \
    gmp-dev \
    libzip-dev \
    libmcrypt-dev \
    openldap-dev \
&& apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    zlib-dev \
    libpng-dev \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& docker-php-ext-install \
    gd \
    ldap \
    zip \
    gmp \
    pdo \
    pdo_mysql \
&&  pecl install \
    mcrypt \
&& docker-php-ext-enable \
    mcrypt \
&& apk del .build-deps 

RUN mkdir -p /run/nginx

COPY config/nginx.conf /etc/nginx/conf.d/default.conf
COPY config/supervisor.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
