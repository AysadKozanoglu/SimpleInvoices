#!/bin/bash

### modify config/config.php
nonce_key=$(mcookie)
sed -i /var/www/si.example.org/config/config/php \
    -e "/^email.host/ c email.host = smtp.gmail.com" \
    -e "/^email.smtp_auth/ c email.smtp_auth = true" \
    -e "/^email.username/ c email.username = $gmail_address" \
    -e "/^email.password/ c email.password = $gmail_password" \
    -e "/^email.smtpport/ c email.smtpport = 465" \
    -e "/^email.secure/ c email.secure = SSL" \
    -e "/^email.ack/ c email.ack = false" \
    -e "/^email.use_local_sendmail/ c email.use_local_sendmail = false" \
    -e "/^nonce.key/ c nonce.key = $nonce_key"
