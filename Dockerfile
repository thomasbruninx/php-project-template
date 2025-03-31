FROM php:8.3-apache AS base
RUN apt-get update
RUN apt-get install -y libzip-dev libicu-dev
RUN docker-php-ext-install mysqli zip intl pdo pdo_mysql
RUN apt-get install -y libfreetype-dev libjpeg62-turbo-dev libpng-dev libwebp-dev zlib1g-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && docker-php-ext-install -j$(nproc) gd

FROM composer:lts AS dependencies
WORKDIR /app
RUN --mount=type=bind,source=composer.json,target=composer.json \
    --mount=type=bind,source=composer.lock,target=composer.lock \
    --mount=type=cache,target=/tmp/cache \
    composer install --no-dev --no-interaction --ignore-platform-reqs

FROM composer:lts AS dependencies-dev
WORKDIR /app
RUN --mount=type=bind,source=composer.json,target=composer.json \
    --mount=type=bind,source=composer.lock,target=composer.lock \
    --mount=type=cache,target=/tmp/cache \
    composer install --no-interaction --ignore-platform-reqs

FROM base AS debug
COPY --from=dependencies-dev /usr/bin/composer /usr/bin/composer
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

FROM base AS release
COPY --from=dependencies app/vendor/ /var/www/vendor
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY config/php/*.ini $PHP_INI_DIR/conf.d/
COPY config/httpd/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./src /var/www/src
COPY ./public /var/www/public
USER www-data
