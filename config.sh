#!/bin/bash -x

### get config settings from a file
if [ "$1" != '' ]
then
    settings=$1
    set -a
    source  $settings
    set +a
fi

inv=/usr/local/src/invoices/install

$inv/config/domain.sh
$inv/config/mysql_passwords.sh
$inv/config/mysql_invoices.sh
$inv/config/gmailsmtp.sh
#$inv/config/drupalpass.sh
$inv/config/ssh_keys.sh
