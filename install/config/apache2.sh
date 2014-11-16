#!/bin/bash -x
### Configure apache2.

a2enmod ssl
a2dissite 000-default
a2ensite inv inv-ssl
a2enmod headers rewrite

ln -sf /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enconf downloads phpmyadmin

sed -i /etc/php5/apache2/php.ini \
    -e '/^\[PHP\]/ a apc.rfc1867 = 1' \
    -e '/^display_errors/ c display_errors = On'

sed -i /etc/apache2/mods-available/mpm_prefork.conf \
    -e '/^<IfModule/,+5 s/StartServers.*/StartServers 2/' \
    -e '/^<IfModule/,+5 s/MinSpareServers.*/MinSpareServers 2/' \
    -e '/^<IfModule/,+5 s/MaxSpareServers.*/MaxSpareServers 4/' \
    -e '/^<IfModule/,+5 s/MaxRequestWorkers.*/MaxRequestWorkers 50/'
