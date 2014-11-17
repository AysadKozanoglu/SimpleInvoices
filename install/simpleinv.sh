#!/bin/bash -x
### Install simpleinvoices.

#export DEBIAN_FRONTEND=noninteractive

### get the code of simple-invoices
cd /var/www/
# wget http://download.simpleinvoices.org/simpleinvoices/downloads/simpleinvoices.2013.1.beta.7.zip
# unzip simpleinvoices.2013.1.beta.7.zip
# mv simpleinvoices.2013.1.beta.7 inv.example.org
git clone --recursive https://github.com/simpleinvoices/simpleinvoices inv.example.org

### make /tmp dir writable by webserver 
chown www-data: -R /var/www/inv.example.org/tmp/

