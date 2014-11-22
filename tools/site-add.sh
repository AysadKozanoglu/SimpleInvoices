#!/bin/bash
### Create a new site.

### get the parameters
if [ $# -ne 1 ]
then
    echo " * Usage: $0 <domain_config.sh>"
    exit 1
fi
domain_config=$1
source $domain_config

if [ -d "/var/www/$domain" ]
then
    echo "Domain $domain already exists."
    exit 2
fi

### copy the root directory
cp -a /var/www/si.example.org /var/www/$domain
chown www-data: -R /var/www/$domain/tmp
chown root: /var/www/$domain/tmp/.htaccess

### add to /etc/hosts
sed -i /etc/hosts.conf -e "/^127.0.0.1 $domain/d"
echo "127.0.0.1 $domain" >> /etc/hosts.conf
/etc/hosts_update.sh

### database and user settings
db_name=$(echo $domain | tr -d '_.-')
db_user=u$(mcookie | head -c 15)
db_pass=$(mcookie | head -c 16)

### create a new database and user
mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
$mysql -e "
    DROP DATABASE IF EXISTS $db_name;
    CREATE DATABASE $db_name;
    GRANT ALL ON $db_name.* TO '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
"

### import the tables and initial data
if [ "$sample" = 'true' ]
then
    file_sql=/etc/invoices/invoices-sample.sql
else
    file_sql=/etc/invoices/invoices.sql
fi
$mysql -D $db_name < $file_sql

### change email and password of the admin user
hashpwd=$(echo -n $password | md5sum | cut -d' ' -f1)
$mysql -e "
    USE $db_name;
    UPDATE si_user
    SET
        email = '$email',
        password = '$hashpwd'
    WHERE id = 1
"

### modify config.php
sed -i /var/www/$domain/config/config.php \
    -e "/^database.params.username/ c database.params.username = $db_user" \
    -e "/^database.params.password/ c database.params.password = $db_pass" \
    -e "/^database.params.dbname/ c database.params.dbname = $db_name" \
    -e "/^authentication.enabled/ c authentication.enabled = true"

### modify the configuration of apache2
rm -f /etc/apache2/sites-{available,enabled}/$domain{,-ssl}.conf
rm -f /etc/apache2/sites-{available,enabled}/m.$domain{,-ssl}.conf
cp /etc/apache2/sites-available/{si.example.org,$domain}.conf
cp /etc/apache2/sites-available/{si.example.org-ssl,$domain-ssl}.conf
cp /etc/apache2/sites-available/m.{si.example.org,$domain}.conf
cp /etc/apache2/sites-available/m.{si.example.org-ssl,$domain-ssl}.conf
for config_file in $domain.conf $domain-ssl.conf m.$domain.conf m.$domain-ssl.conf
do
    sed -i /etc/apache2/sites-available/$config_file \
        -e "s/si\.example\.org/$domain/g"
done 
a2ensite $domain $domain-ssl m.$domain m.$domain-ssl

### reload apache2 configuration
/etc/init.d/apache2 reload
