#!/bin/bash

SQL_PASSWORD=$(cat ${SQL_PASSWORD_FILE})
WP_USER_PASSWORD=$(cat ${WP_USER_PASSWORD_FILE})
WP_ADMIN_PASSWORD=$(cat ${WP_ADMIN_PASSWORD_FILE})

mkdir -p /var/www/wordpress
cd /var/www/wordpress

if [ ! -f wp-config.php ]; then
	wp core download --allow-root

	until mysqladmin -h mariadb ping --silent; do
		sleep 1
	done

	wp config create --dbname=${SQL_DATABASE} --dbuser=${SQL_USER} --dbpass=${SQL_PASSWORD} --dbhost=mariadb --allow-root
	wp core install --url=${DOMAIN_NAME} --title="Inception" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --allow-root
	wp user create ${WP_USER} ${WP_USER_EMAIL} --role=author --user_pass=${WP_USER_PASSWORD} --allow-root

fi

exec "$@"