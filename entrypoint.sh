#!/usr/bin/env bash

#crond -l 2 -f -c /etc/crontabs -f &

exec php-fpm -F