#!/bin/bash -x
### Add a new domain.

### get parameters
if [ $# -ne 2 ]
then
    echo "Usage: $0 <container> <domain_config.sh>
"
    exit 1
fi
container=$1
domain_config=$2

### add a new site inside the container
rm -f $(dirname $0)/domain_config.sh
cp -a $domain_config $(dirname $0)/domain_config.sh
docker exec -t $container /app/tools/site-add.sh /app/domain_config.sh
rm $(dirname $0)/domain_config.sh

### the rest of the script is about configuration of wsproxy
test -d /data/wsproxy || exit

### get the $domain from the config file
source $domain_config

### add on wsproxy apache2 config files for the new domain
cd /data/wsproxy/config/etc/apache2/sites-available/
cp si.example.org.conf $domain.conf
cp m.si.example.org.conf m.$domain.conf
cp si.example.org-ssl.conf $domain-ssl.conf
cp m.si.example.org-ssl.conf m.$domain-ssl.conf
for config_file in $domain.conf m.$domain.conf $domain-ssl.conf m.$domain-ssl.conf
do
    sed -i $config_file -e "s/si\.example\.org/$domain/g"
    ln -s ../sites-available/$config_file ../sites-enabled/
done
cd /data/

### modify the configuration of wsproxy/hosts.txt
sed -i /data/wsproxy/hosts.txt -e "/^$container: $domain/d"
sed -i /data/wsproxy/hosts.txt -e "/^$container: m\.$domain/d"
cat << EOF >> /data/wsproxy/hosts.txt
$container: $domain
$container: m.$domain
EOF

### restart wsproxy
/data/wsproxy/restart.sh
sleep 5
docker exec -t wsproxy /etc/init.d/apache2 restart
