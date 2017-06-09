#!/bin/bash

docker rm laravel-nginx -f
docker build -t josrom/laravel-nginx-docker:v5.4 .
docker ps -a
docker create -it --name laravel-nginx -p 8000:80 -p 44300:443 -p 2222:22 josrom/laravel-nginx-docker:5.4
docker start laravel-nginx -i