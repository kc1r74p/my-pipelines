#!/bin/bash

set +x
ls
echo
pwd
echo
echo "Days left SSL cert:"
cat ../../boring_cloud_ssl/info.txt  
apk add python3 py3-setuptools wget 2>&1 >/dev/null

wget https://dl.eff.org/certbot-auto
mv certbot-auto /usr/local/bin/certbot-auto
chown root /usr/local/bin/certbot-auto
chmod 0755 /usr/local/bin/certbot-auto

cd ../../dns-inwx-challenge
python3 setup.py develop --no-deps

mkdir /etc/letsencrypt/
cat >/etc/letsencrypt/inwx.cfg <<EOL
certbot_dns_inwx:dns_inwx_url           = https://api.domrobot.com/xmlrpc/
certbot_dns_inwx:dns_inwx_username      = ((inwxUser))
certbot_dns_inwx:dns_inwx_password      = ((inwxPass))
EOL

cd -
#cd ../../certbot
./certbot-auto certonly \
--dry-run \
-a certbot-dns-inwx:dns-inwx \
--certbot-dns-inwx:dns-inwx-propagation-seconds 600 \
--agree-tos --manual-public-ip-logging-ok --email $mail \
-d '*.boring.cloud' -d 'boring.cloud' -d '*.eu1.dev' -d 'eu1.dev' \
--preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory 
