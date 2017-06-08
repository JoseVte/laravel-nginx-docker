FROM ubuntu:16.04
MAINTAINER Jose Vicente Orts <jvortsromero@gmail.com>
LABEL autor="Jose Vicente Orts Romero"
LABEL version="1.0"

ENV DEBIAN_FRONTEND noninteractive

# Update
RUN apt-get update && apt-get -y dist-upgrade

# Seed database password
COPY mysqlpwdseed /root/mysqlpwdseed
RUN debconf-set-selections /root/mysqlpwdseed

# NGINX, PHP, composer, supervisor
RUN apt-get install nginx git php7.0 php7.0-curl php7.0-fpm php7.0-gd php7.0-mbstring php7.0-xml php7.0-mysql php7.0-mcrypt php7.0-zip curl nano supervisor -y
RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php && /bin/mv composer.phar /usr/local/bin/composer

## Configuration
RUN sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cgi.log/' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cli.log/' /etc/php/7.0/cli/php.ini

COPY files/root /
RUN ln -fs /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default 

WORKDIR /var/www/
#VOLUME /var/www/

RUN composer create-project laravel/laravel /var/www/laravel --prefer-dist
RUN chown www-data:www-data -R /var/www/laravel/storage /var/www/laravel/bootstrap/cache

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]