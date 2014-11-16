#!/bin/bash
### Delete a site.

### get the parameters
if [ $# -ne 1 ]
then
    echo " * Usage: $0 domain"
    exit 1
fi
domain=$1

if [ -d "/var/www/$domain" ]
then
    echo "Domain $domain already exists."
    exit 2
fi

### remove the configuration of apache2
rm -f /etc/apache2/sites-{available,enabled}/$domain{,-ssl}.conf
/etc/init.d/apache2 reload

### drop the database
dbname=$domain
mysql --defaults-file=/etc/mysql/debian.cnf \
      -e "DROP DATABASE IF EXISTS $dbname;"

### remove the directory
rm -rf /var/www/$domain

### remove from /etc/hosts
sed -i /etc/hosts.conf -e "/^127.0.0.1 $domain/d"
/etc/hosts_update.sh
