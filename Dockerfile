# FROM wordpress:cli-php7.2
# let's use a circleci based image so we can have a faster checkout in workflows
FROM circleci/php:7.1-jessie-node-browsers

WORKDIR /tmp/

USER root

## Install PhpUnit
RUN curl -SL --insecure "https://phar.phpunit.de/phpunit.phar" -o phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/bin/phpunit

## Install PHPCS
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar && \
    cp /tmp/phpcs.phar /usr/local/bin/phpcs && \
    chmod +x /usr/local/bin/phpcs

# Set some useful defaults to phpcs
# show_progress - I like to see a progress while phpcs does its magic
# colors - Enable colors; My terminal supports more than black and white
# report_width - I am using a large display so I can afford a larger width
# encoding - Unicode all the way
RUN /usr/local/bin/phpcs --config-set show_progress 1 && \
    /usr/local/bin/phpcs --config-set colors 1 && \
    /usr/local/bin/phpcs --config-set report_width 140 && \
    /usr/local/bin/phpcs --config-set encoding utf-8

### If we are ditching wpcli image we need this:
RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

### At some point we should return to the base user, but not now yet.
# USER www-data

### Install deps
# RUN apk update \
#     && apk add --no-cache git openssh bash curl docker python2 py2-pip mysql-client libmcrypt libmcrypt-dev \
#     libxml2-dev freetype-dev libpng-dev libjpeg-turbo-dev g++ make autoconf \
#     && apk add rsync \
#     # && docker-php-source extract \
#     # && pecl install xdebug redis \
#     # && docker-php-ext-enable xdebug redis \
#     # && docker-php-source delete \
#     # && docker-php-ext-install mcrypt pdo_mysql soap \
#     # && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
#     # && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    # && rm -rf /tmp/*

### Now that we have composer, let's add WPCS
RUN composer create-project wp-coding-standards/wpcs:dev-master --no-interaction --no-dev /var/lib/wpcs

RUN /usr/local/bin/phpcs --config-set installed_paths /var/lib/wpcs

EXPOSE 9000
