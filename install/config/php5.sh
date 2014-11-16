#!/bin/bash -x
### Modify the configuration of php5.

cat <<EOF > /etc/php5/conf.d/apc.ini
extension=apc.so
apc.mmap_file_mask=/tmp/apc.XXXXXX
apc.shm_size=96M
EOF

sed -i /etc/php5/apache2/php.ini \
    -e '/^;\?memory_limit/ c memory_limit = 64M' \
    -e '/^;\?max_execution_time/ c max_execution_time = 90' \
    -e '/^;\?display_errors/ c display_errors = On' \
    -e '/^;\?post_max_size/ c post_max_size = 16M' \
    -e '/^;\?cgi\.fix_pathinfo/ c cgi.fix_pathinfo = 1' \
    -e '/^;\?upload_max_filesize/ c upload_max_filesize = 16M' \
    -e '/^;\?default_socket_timeout/ c default_socket_timeout = 90'
