#!/bin/bash
pkill mysqld
pkill php-fpm
pkill nginx
echo 'kill all';
