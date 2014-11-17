#!/bin/bash -x
### Add a new domain to wsproxy.

### get parameters
if [ $# -ne 2 ]
then
    echo "Usage: $0 container domain
"
    exit 1
fi
container=$1
domain=$2

### add a new site inside the container
docker exec $container /app/tools/site-add $domain

### add on wsproxy apache2 config files for the new domain
cd /data/wsproxy/config/etc/apache2/sites-available/
cp xmp.conf $domain.conf
cp xmp-ssl.conf $domain-ssl.conf
sed -i $domain.conf -e "s/example\.org/$domain/g"
sed -i $domain-ssl.conf -e "s/example\.org/$domain/g"

cd ../sites-enabled/
ln -s ../sites-available/$domain.conf .
ln -s ../sites-available/$domain-ssl.conf .
cd /data/

### modify the configuration of wsproxy/hosts.txt
sed -i /data/wsproxy/hosts.txt -e "/^$container: $domain/d"
cat << EOF >> /data/wsproxy/hosts.txt
$container: $domain
EOF

### restart wsproxy
/data/wsproxy/restart.sh
