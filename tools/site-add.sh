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
cp -a /var/www/inv /var/www/$domain
chown www-data: -R /var/www/$domain/tmp
chown root: /var/www/$domain/tmp/.htaccess

### add to /etc/hosts
sed -i /etc/hosts.conf -e "/^127.0.0.1 $domain/d"
echo "127.0.0.1 $domain" >> /etc/hosts.conf
/etc/hosts_update.sh

### create a new database
mysql --defaults-file=/etc/mysql/debian.cnf -e "
    DROP DATABASE IF EXISTS $dst;
    CREATE DATABASE $dst;
    GRANT ALL ON $dst.* TO btr@localhost;
"

### modify settings.php
domain=$(head -n 1 /etc/hosts.conf | cut -d' ' -f3)
sub=${dst#*_}
hostname=$sub.$domain
sed -i $dst_dir/sites/default/settings.php \
    -e "/^\\\$databases = array/,+10  s/'database' => .*/'database' => '$dst',/" \
    -e "/^\\\$base_url/c \$base_url = \"https://$hostname\";" \
    -e "/^\\\$conf\['memcache_key_prefix'\]/c \$conf['memcache_key_prefix'] = '$dst';"


### copy and modify the configuration of apache2
rm -f /etc/apache2/sites-{available,enabled}/$domain{,-ssl}.conf
cp /etc/apache2/sites-available/{inv,$domain}.conf
cp /etc/apache2/sites-available/{inv-ssl,$domain-ssl}.conf
sed -i /etc/apache2/sites-available/$domain.conf \
    -e "s#ServerName .*#ServerName $domain#" \
    -e "s#RedirectPermanent .*#RedirectPermanent / https://$domain/#" \
    -e "s#$src_dir#$dst_dir#g"
sed -i /etc/apache2/sites-available/$domain-ssl.conf \
    -e "s#ServerName .*#ServerName $domain#" \
    -e "s#$src_dir#$dst_dir#g"
a2ensite $domain $domain-ssl

### reload apache2 configuration
/etc/init.d/apache2 reload
#/etc/init.d/mysql restart
