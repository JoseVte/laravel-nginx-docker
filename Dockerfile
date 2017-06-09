FROM richarvey/nginx-php-fpm:php7
MAINTAINER Jose Vicente Orts <jvortsromero@gmail.com>
LABEL autor="Jose Vicente Orts Romero"
LABEL version="1.0"

ENV LARAVEL_VERSION 5.4.*

# Update
RUN apk update && apk upgrade

# Install sshd
RUN apk add openssh-server openssh-client curl nano supervisor git

# PHP, composer
#RUN apt-get install php7.0 php7.0-curl php7.0-fpm php7.0-gd php7.0-mbstring php7.0-xml php7.0-mysql php7.0-mcrypt php7.0-zip -y
RUN apk add php7-tokenizer
RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php && /bin/mv composer.phar /usr/local/bin/composer
WORKDIR /var/www/laravel/
RUN adduser -D -u 1000 laravel && chown -R laravel /var/www/laravel/
USER laravel
RUN composer create-project laravel/laravel=${LARAVEL_VERSION} /var/www/laravel --prefer-dist 
USER root

ADD files/entrypoint.sh /
ADD files/laravel.conf /etc/nginx/sites-enabled/
RUN ln -fs /etc/nginx/sites-enabled/laravel.conf /etc/nginx/sites-available/laravel.conf 

EXPOSE 22 80 443

ENTRYPOINT ["/entrypoint.sh"]