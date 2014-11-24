#!/bin/bash -x
### Configure the system and the application.

### get config settings from a file
if [ "$1" != '' ]
then
    settings=$1
    set -a
    source  $settings
    set +a
fi

### go to the directory of the script
cd $(dirname $0)

### copy config files to the system
cp -TdR overlay/ /

config/simpleinv.sh
config/cache.sh
config/apache2.sh
config/php5.sh
config/sshd.sh
config/mysql_passwords.sh

#config/domain.sh
#config/mysql_invoices.sh
#config/gmailsmtp.sh
#config/drupalpass.sh
