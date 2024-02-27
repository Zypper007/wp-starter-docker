#!/bin/bash
set -e

until mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -e 'SELECT 1'; do
  echo "Waiting for database connection..."
  sleep 5
done

if [ ! -f wp-config.php ]; then
  startup.sh
fi

chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

exec "$@"
