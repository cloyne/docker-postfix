#/bin/bash -e

mkdir -p /srv/var/log/postfix
mkdir -p /srv/postfix

docker run -d -p 50.0.115.228:25:25/tcp -p 50.0.115.228:465:465/tcp -p 50.0.115.228:587:587/tcp --name mail -h mail.cloyne.net -e MAILNAME=mail.cloyne.net -e MY_NETWORKS='172.17.0.0/16 50.0.115.224/28 127.0.0.0/8' -e ROOT_ALIAS='clonm@bsc.coop,mitar.cloyne@tnode.com' -v /srv/var/log/postfix:/var/log/postfix -v /srv/postfix:/var/spool/postfix cloyne/postfix
