#!/bin/bash -x
### Install simpleinvoices.

#export DEBIAN_FRONTEND=noninteractive

### get the code of simple-invoices
cd /var/www/
git clone https://github.com/FreeSoft-AL/simpleinvoices si.example.org
cd si.example.org/
git clone https://github.com/dmelo/Zend-1.11
rmdir library/Zend
mv Zend-1.11 library/Zend

### make /tmp dir writable by webserver 
chown www-data: -R tmp/
chown root: tmp/.htaccess

