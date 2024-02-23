#!/bin/bash
set -e

until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -e 'SELECT 1'; do
  echo "Waiting for database connection..."
  sleep 5
done

if [ ! -f wp-config.php ]; then
wp config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=${DB_HOST} --allow-root
sed -i "2irequire_once(dirname(__FILE__) . '/dev-config.php');" wp-config.php
wp core install --url=https://${SITE_URL} --title="$SITE_NAME" --admin_user=${ADMIN_NAME} --admin_password=${ADMIN_PASS} --admin_email=${ADMIN_EMAIL} --locale=${WP_LOCALE} --allow-root
# @todo: zrobić multisite
# wp core multisite-install --subdomains --title="$SITE_NAME" --admin_user=${ADMIN_NAME} --admin_password=${ADMIN_PASS} --admin_email=${ADMIN_EMAIL} --allow-root

# Po mapowaniu katalogu zostaje nadpisany dlatego przywracam go z kopii
tar -xzf ./wp-content.tar.gz
rm -f ./wp-content.tar.gz

wp plugin install \
    custom-post-type-ui \
    user-role-editor \
    advanced-custom-fields \
  --activate --allow-root
fi

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

exec "$@"
