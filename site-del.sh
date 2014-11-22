#!/bin/bash -x
### Remove a domain.

### get parameters
if [ $# -ne 2 ]
then
    echo "Usage: $0 container domain
"
    exit 1
fi
container=$1
domain=$2

### delete the site from the container
docker exec -t $container /app/tools/site-del.sh $domain

### the rest of the script is about configuration of wsproxy
test -d /data/wsproxy || exit

### remove apache2 config files from wsproxy
rm /data/wsproxy/config/etc/apache2/sites-{available,enabled}/$domain{,-ssl}.conf
rm /data/wsproxy/config/etc/apache2/sites-{available,enabled}/m.$domain{,-ssl}.conf

### modify the configuration of wsproxy/hosts.txt
sed -i /data/wsproxy/hosts.txt -e "/^$container: $domain/d"
sed -i /data/wsproxy/hosts.txt -e "/^$container: m\.$domain/d"

### restart wsproxy
/data/wsproxy/restart.sh
sleep 5
docker exec -t wsproxy /etc/init.d/apache2 restart
