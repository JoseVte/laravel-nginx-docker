#!/bin/bash

docker rm laravel-nginx -f
docker build -t josrom/laravel-nginx:alpha .
#docker rm laravel-nginx laravel-mysql -f
docker ps -a
docker create -it --name laravel-nginx -p 8000:80 -p 44300:443 josrom/laravel-nginx:alpha
#docker create -it -d --name laravel-mysql -p 33060:3306 josrom/laravel-mysql:alpha
docker start laravel-nginx -i