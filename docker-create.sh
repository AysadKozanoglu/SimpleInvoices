#!/bin/bash -x
### Create a new container for invoices.

### set some variables
container=${1:-invoices}
domain=${2:-si.example.org}

### create a new container
docker create --name="$container" --hostname="$domain" \
    -v /data/invoices:/app:ro invoices

### the rest of the script is about configuration of wsproxy
test -d /data/wsproxy || exit

### add example config files in the configuration of wsproxy
domain='si.example.org'
cd /data/wsproxy/config/etc/apache2/sites-available/
test -f $domain.conf && exit

cp xmp.conf $domain.conf 
cp xmp.conf m.$domain.conf 
cp xmp-ssl.conf $domain-ssl.conf 
cp xmp-ssl.conf m.$domain-ssl.conf 

sed -i $domain.conf -e "s/example\.org/$domain/g"
sed -i m.$domain.conf -e "s/example\.org/m.$domain/g"
sed -i $domain-ssl.conf -e "s/example\.org/$domain/g"
sed -i m.$domain-ssl.conf -e "s/example\.org/m.$domain/g"
