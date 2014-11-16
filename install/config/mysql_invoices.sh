#!/bin/bash
### set password for the mysql user inv

### get a new password for the mysql user 'inv'
if [ "$mysql_passwd_inv" = 'random' ]
then
    mysql_passwd_inv=$(mcookie | head -c 16)
elif [ -z "${mysql_passwd_inv+xxx}" -o "$mysql_passwd_inv" = '' ]
then
    echo
    echo "===> Please enter new password for the MySQL 'inv' account. "
    echo
    mysql_passwd_inv=$(mcookie | head -c 16)
    stty -echo
    read -p "Enter password [$mysql_passwd_inv]: " passwd
    stty echo
    echo
    mysql_passwd_inv=${passwd:-$mysql_passwd_inv}
fi

### set password
source $(dirname $0)/set_mysql_passwd.sh
set_mysql_passwd inv $mysql_passwd_inv

### modify the configuration file of Drupal (settings.php)
for file in $(ls /var/www/inv*/sites/default/settings.php)
do
    sed -i $file \
	-e "/^\\\$databases = array/,+10  s/'password' => .*/'password' => '$mysql_passwd_inv',/"
done
