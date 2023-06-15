FROM wordpress:php8.0-apache

# Install system dependencies
RUN set -e; \
    apt-get update -y && apt-get install -y \
    gnupg2 \
    tini \
    lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse && apt-get clean

COPY ./custom-php.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www/html
COPY ./wp-config.php /var/www/html/wp-config.php
COPY ./.htaccess /var/www/html/.htaccess
COPY ./svc.json /var/www/html/svc.json
COPY ./wp-content /var/www/html/wp-content

COPY docker-entrypoint.sh /usr/local/bin/

#creating wp-supercache directory
RUN mkdir -p /wp/cache
RUN chown -R www-data:www-data /wp/cache
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

#Over-riding the docker entry script
ENTRYPOINT ["/usr/bin/tini", "--", "docker-entrypoint.sh"]
CMD ["apache2-foreground"]


