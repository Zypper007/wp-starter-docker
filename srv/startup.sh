#!/bin/bash

wp core download --locale=${WP_LOCALE} --version=${WP_VERSION} --allow-root
wp config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=${DB_HOST} --allow-root
wp core install --url=https://${SITE_URL} --title="$SITE_NAME" --admin_user=${ADMIN_NAME} --admin_password=${ADMIN_PASS} --admin_email=${ADMIN_EMAIL} --locale=${WP_LOCALE} --allow-root

# @todo: make multisite
# wp core multisite-install --subdomains --title="$SITE_NAME" --admin_user=${ADMIN_NAME} --admin_password=${ADMIN_PASS} --admin_email=${ADMIN_EMAIL} --allow-root
sed -i "2irequire_once(dirname(__FILE__) . '/dev-config.php');" wp-config.php

wp plugin install \
    custom-post-type-ui \
    user-role-editor \
    advanced-custom-fields \
  --activate --allow-root
