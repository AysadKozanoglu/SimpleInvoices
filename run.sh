#!/bin/bash -x
### Installs a container for invoices

### set some variables
container="invoices"
domain="inv.example.org"

### create a new container
docker create --name=$container --hostname=$domain \
    -v /data/invoices:/app:ro invoices
docker start $container

### add on wsproxy apache2 config files for the new site
cd /data/wsproxy/config/etc/apache2/sites-available/
for file in xmp.conf xmp-ssl.conf
do
    file1=${file/#xmp/inv}
    cp $file $file1
    sed -i $file1 -e "s/example\.org/$domain/g"
done
cd ../sites-enabled/
ln -s ../sites-available/inv.conf .
ln -s ../sites-available/inv-ssl.conf .
cd /data/

### modify the configuration of wsproxy/hosts.txt
sed -i /data/wsproxy/hosts.txt -e "/^$container:/d"
cat << EOF >> /data/wsproxy/hosts.txt
$container: $domain
EOF

### restart wsproxy
/data/wsproxy/restart.sh
