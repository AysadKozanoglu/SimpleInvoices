#!/bin/bash -x
### Customize the configuration of sshd.

sed -i /etc/ssh/sshd_config \
    -e 's/^Port/#Port/' \
    -e 's/^PasswordAuthentication/#PasswordAuthentication/' \
    -e 's/^X11Forwarding/#X11Forwarding/'

sed -i /etc/ssh/sshd_config \
    -e '/^### custom config/,$ d'

sshd_port=${sshd_port:-2201}
cat <<EOF >> /etc/ssh/sshd_config
### custom config
Port $sshd_port
PasswordAuthentication no
X11Forwarding no
EOF

### generate ssh public/private keys
mkdir -p ~/.ssh
chmod 700 ~/.ssh
rm -f ~/.ssh/id_rsa
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ''
mv ~/.ssh/{id_rsa.pub,authorized_keys}
