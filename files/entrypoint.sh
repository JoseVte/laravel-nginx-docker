#!/bin/bash

set -e

chown -R laravel /var/www/laravel/storage

exec supervisord --nodaemon
