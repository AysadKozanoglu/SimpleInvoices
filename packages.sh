#!/bin/bash -x

DEBIAN_FRONTEND=noninteractive

### upgrade packages
apt-get update
apt-get -y upgrade

### install other needed packages
apt-get -y install aptitude vim cron ssmtp git wget curl diffutils
apt-get -y install apache2 mysql-server php5 php5-mysql \
                   php5-gd php-xsl phpmyadmin ssl-cert
