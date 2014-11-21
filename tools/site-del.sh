#!/bin/bash
### Delete a site.

### get the parameters
if [ $# -ne 1 ]
then
    echo " * Usage: $0 domain"
    exit 1
fi
domain=$1

### remove the configuration of apache2
rm -f /etc/apache2/sites-{available,enabled}/$domain{,-ssl}.conf
rm -f /etc/apache2/sites-{available,enabled}/m.$domain{,-ssl}.conf
/etc/init.d/apache2 reload

### drop the database and the user
db_name=$(echo $domain | tr -d '_.-')
db_user=$db_name
mysql --defaults-file=/etc/mysql/debian.cnf \
      -e "DROP DATABASE IF EXISTS $db_name;
          GRANT USAGE ON *.* TO '$db_user'@'localhost';
          DROP USER '$db_user'@'localhost';"

### remove the directory
rm -rf /var/www/$domain

### remove from /etc/hosts
sed -i /etc/hosts.conf -e "/^127.0.0.1 $domain/d"
/etc/hosts_update.sh
