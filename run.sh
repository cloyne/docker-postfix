#/bin/bash -e

mkdir -p /srv/var/log/postfix
mkdir -p /srv/postfix
mkdir -p /srv/sympa/etc/shared

docker run -d -p 50.0.115.228:25:25/tcp -p 50.0.115.228:465:465/tcp -p 50.0.115.228:587:587/tcp --name mail -h mail.cloyne.net -e MAILNAME=mail.cloyne.net -e MY_NETWORKS='192.168.0.0/16 172.17.0.0/16 50.0.115.224/28 127.0.0.0/8' -e ROOT_ALIAS='clonm@bsc.coop,mitar.cloyne@tnode.com' -e MY_DESTINATION='localhost.localdomain localhost mail.cloyne.net' -v /srv/var/log/postfix:/var/log/postfix -v /srv/postfix:/var/spool/postfix -v /srv/sympa/etc/shared:/etc/sympa/shared cloyne/postfix
