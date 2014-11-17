#!/bin/bash
### Remove a domain from wsproxy.

### get parameters
if [ $# -ne 2 ]
then
    echo "Usage: $0 container domain
"
    exit 1
fi
container=$1
domain=$2

### remove apache2 config files from wsproxy
rm /data/wsproxy/config/etc/apache2/sites-{available,enabled}/$domain{,-ssl}.conf

### modify the configuration of wsproxy/hosts.txt
sed -i /data/wsproxy/hosts.txt -e "/^$container: $domain/d"

### restart wsproxy
/data/wsproxy/restart.sh

### delete the site from the container
docker exec $container /app/tools/site-del $domain

