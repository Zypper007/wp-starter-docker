FROM php:8.2-apache

# dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libpng-dev \
    libwebp-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    default-libmysqlclient-dev \
    zip \
    unzip \
    openssh-client \
    default-mysql-client \
    git \
    curl \
  && apt-get clean && rm -rf /var/lib/apt/lists/

RUN pecl install xdebug \
  && pecl install xmlrpc-1.0.0RC3 \
  && pecl install imagick \
  && pecl install apcu \
  && docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype \
  && docker-php-ext-install pdo_pgsql \
  && docker-php-ext-install pgsql \
  && docker-php-ext-install mbstring \
  && docker-php-ext-install exif \
  && docker-php-ext-install pcntl \
  && docker-php-ext-install bcmath \
  && docker-php-ext-install gd \
  && docker-php-ext-install zip \
  && docker-php-ext-install soap \
  && docker-php-ext-install intl \
  && docker-php-ext-install mysqli \
  && docker-php-ext-enable xdebug \
  && docker-php-ext-enable xmlrpc \
  && docker-php-ext-enable imagick \
  && docker-php-ext-enable apcu

RUN usermod -aG www-data root

# default env
ARG GIT_USERNAME=""
ENV GIT_USERNAME=${GIT_USERNAME}
ARG GIT_EMAIL=""
ENV GIT_EMAIL=${GIT_EMAIL}
ARG NODE_VERSION=20
ENV NODE_VERSION=${NODE_VERSION}
ARG WP_LOCALE=pl_PL
ENV WP_LOCALE=${WP_LOCALE}
ARG WP_VERSION=latest
ENV WP_VERSION=${WP_VERSION}
ARG DB_NAME=wordpress
ENV DB_NAME=${DB_NAME}
ARG DB_USER=root
ENV DB_USER=${DB_USER}
ARG DB_PASS=!A2s3d4f
ENV DB_PASS=${DB_PASS}
ARG DB_HOST=db
ENV DB_HOST=${DB_HOST}
ARG SITE_URL=wordpress.local
ENV SITE_URL=${SITE_URL}
ARG SITE_NAME=Wordpress Starter
ENV SITE_NAME=${SITE_NAME}
ARG ADMIN_NAME=admin
ENV ADMIN_NAME=${ADMIN_NAME}
ARG ADMIN_PASS=!A2s3d4f
ENV ADMIN_PASS=${ADMIN_PASS}
ARG ADMIN_EMAIL=admin@wordpress.local
ENV ADMIN_EMAIL=${ADMIN_EMAIL}
ARG SMTP_SERVER=mailhog
ENV SMTP_SERVER=${SMTP_SERVER}
ARG SMTP_PORT=1025
ENV SMTP_PORT=${SMTP_PORT}
ARG PHP_EXECUTION_TIME=300
ENV PHP_EXECUTION_TIME=${PHP_EXECUTION_TIME}
ARG PHP_MEMORY_LIMIT=1G
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT}

#git config
RUN git config --global user.name "$GIT_USERNAME" && git config --global user.email "$GIT_EMAIL"

# untils install
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
  && apt-get install -y nodejs \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# download wordpress
WORKDIR /var/www/html/

COPY ./wordpress/dev-config.php .
RUN wp core download --locale=${WP_LOCALE} --version=${WP_VERSION} --allow-root
RUN tar -czvf wp-content.tar.gz ./wp-content

# ssl
WORKDIR /etc

RUN echo "ServerName $SITE_URL" >> ./apache2/apache2.conf
COPY ./ssl/cert.pem ./ssl/certs/cert.pem
COPY ./ssl/key.pem ./ssl/private/key.pem
RUN a2enmod ssl \
  && a2ensite default-ssl \
  && sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/ssl/certs/cert.pem|' ./apache2/sites-available/default-ssl.conf \
  && sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/ssl/private/key.pem|' ./apache2/sites-available/default-ssl.conf

CMD ["apache2-foreground"]

# php setup
WORKDIR /usr/local/etc/php

RUN echo 'xdebug.mode=debug' >> ./conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.start_with_request=yes" >> ./conf.d/docker-php-ext-xdebug.ini \
  && echo 'xdebug.client_host=host.docker.internal' >> ./conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_port=9003" >> ./conf.d/docker-php-ext-xdebug.ini \
  && echo 'apc.enable_cli=1' >> ./conf.d/docker-php-ext-apcu.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && sed -i "s|SMTP = localhost|SMTP = $SMTP_SERVER|" "$PHP_INI_DIR/php.ini" \
  && sed -i "s|smtp_port = 25|smtp_port = $SMTP_PORT|" "$PHP_INI_DIR/php.ini" \
  && sed -i "s|max_execution_time = 30|max_execution_time = $PHP_EXECUTION_TIME|" "$PHP_INI_DIR/php.ini" \
  && sed -i "s|memory_limit = 128M|memory_limit = $PHP_MEMORY_LIMIT|" "$PHP_INI_DIR/php.ini"


COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
WORKDIR /var/www/html/
ENTRYPOINT [ "entrypoint.sh" ]