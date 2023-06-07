FROM wordpress:php8.0-apache

COPY ./custom-php.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/html
COPY ./wp-config.php /var/www/html/wp-config.php
COPY ./.htaccess /var/www/html/.htaccess
COPY ./svc.json /var/www/html/svc.json
COPY ./wp-content /var/www/html/wp-content