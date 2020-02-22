#!/bin/bash

set +x
ls
echo
pwd
echo
echo "Days left SSL cert:"
cat ../../boring_cloud_ssl/info.txt  
apk add python3 py3-setuptools 2>&1 >/dev/null
cd ../../dns-inwx-challenge
python3 setup.py develop --no-deps

mkdir /etc/letsencrypt/
cat >/etc/letsencrypt/inwx.cfg <<EOL
certbot_dns_inwx:dns_inwx_url           = https://api.domrobot.com/xmlrpc/
certbot_dns_inwx:dns_inwx_username      = ((inwxUser))
certbot_dns_inwx:dns_inwx_password      = ((inwxPass))
EOL

cd -
cd ../../certbot
certbot --help certbot-dns-inwx:dns-inwx
