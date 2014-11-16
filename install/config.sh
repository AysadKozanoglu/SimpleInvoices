#!/bin/bash -x
### Configure the system and the application.

### go to the directory of the script
cd $(dirname $0)

### copy config files to the system
cp -TdR overlay/ /

config/cache.sh
config/apache2.sh
config/php.sh
config/sshd.sh

#config/domain.sh
#config/mysql_passwords.sh
#config/mysql_invoices.sh
#config/gmailsmtp.sh
#config/drupalpass.sh
