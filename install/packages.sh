#!/bin/bash -x

DEBIAN_FRONTEND=noninteractive

### upgrade packages
apt-get update
apt-get -y upgrade

### install other needed packages
apt-get -y install aptitude vim cron ssmtp git wget curl diffutils
apt-get -y install apache2 mysql-server php5 php5-mysql php5-apcu \
                   php5-gd php5-xsl phpmyadmin ssl-cert

### generates the file /etc/defaults/locale
update-locale

### change the prompt
sed -i /root/.bashrc \
    -e '/^#force_color_prompt=/c force_color_prompt=yes' \
    -e '/^# get the git branch/,+4 d'
cat <<EOF >> /root/.bashrc
# get the git branch (used in the prompt below)
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
EOF
PS1='\\n\\[\\033[01;32m\\]${debian_chroot:+($debian_chroot)}\\[\\033[00m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\e[32m\\]$(parse_git_branch)\\n==> \\$ \\[\\033[00m\\]'
sed -i /root/.bashrc \
    -e "/^if \[ \"\$color_prompt\" = yes \]/,+2 s/PS1=.*/PS1='$PS1'/"
