#!/bin/bash -x
### Put the cache on RAM (to improve efficiency).

sed -i /etc/fstab \
    -e '/appended by installation scripts/,$ d'

mkdir -p /var/local/cache

cat <<EOF >> /etc/fstab
##### appended by installation scripts
tmpfs		/dev/shm	tmpfs	defaults,noexec,nosuid	0	0
devpts		/dev/pts	devpts	rw,noexec,nosuid,gid=5,mode=620		0	0
# mount /tmp and cache on RAM for better performance
tmpfs  /tmp              tmpfs   defaults,noatime,mode=1777,nosuid    0    0
tmpfs  /var/local/cache  tmpfs	 defaults,mode=0777,noexec,nosuid     0    0
EOF
mount -a

mkdir /var/local/cache/inv/
chown www-data: /var/local/cache/inv/
rm -rf /var/www/inv/tmp/cache
ln -s /var/local/cache/inv /var/www/inv/tmp/cache
