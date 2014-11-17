#!/bin/bash
### Create a new site.

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

### copy the root directory
cp -a /var/www/inv.example.org /var/www/$domain
chown www-data: -R /var/www/$domain/tmp
chown root: /var/www/$domain/tmp/.htaccess

### add to /etc/hosts
sed -i /etc/hosts.conf -e "/^127.0.0.1 $domain/d"
echo "127.0.0.1 $domain" >> /etc/hosts.conf
/etc/hosts_update.sh

### database and user settings
db_name=$(echo $domain | tr -d '_.-')
db_user=$db_name
db_pass=$(mcookie | head -c 16)

### create a new database and user
mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
$mysql -e "
    DROP DATABASE IF EXISTS $db_name;
    CREATE DATABASE $db_name;
    GRANT ALL ON $db_name.* TO '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
"

### import the tables and initial data
$mysql -D $db_name < /etc/invoices/invoices.sql

### modify config.php
sed -i /var/www/$domain/config/config.php \
    -e "/^database.params.username/ c database.params.username = $db_user" \
    -e "/^database.params.password/ c database.params.password = $db_pass" \
    -e "/^database.params.dbname/ c database.params.dbname = $db_name"

### copy and modify the configuration of apache2
rm -f /etc/apache2/sites-{available,enabled}/$domain{,-ssl}.conf
cp /etc/apache2/sites-available/{inv,$domain}.conf
cp /etc/apache2/sites-available/{inv-ssl,$domain-ssl}.conf
sed -i /etc/apache2/sites-available/$domain.conf \
    -e "s/inv\.example\.org/$domain/g"
sed -i /etc/apache2/sites-available/$domain-ssl.conf \
    -e "s/inv\.example\.org/$domain/g"
a2ensite $domain $domain-ssl

### reload apache2 configuration
/etc/init.d/apache2 reload
