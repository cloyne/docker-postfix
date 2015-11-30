#!/bin/bash -e

# A script for running this image at the Cloyne deployment. See the README file for details.
# Moreover, it uses tozd/docker-hosts for service discovery and mounts its volume (/srv/var/hosts).

mkdir -p /srv/var/log/postfix
mkdir -p /srv/postfix
mkdir -p /srv/sympa/etc/shared

docker stop mail || true
sleep 1
docker rm mail || true
sleep 1
docker run --detach=true --restart=always --name mail --hostname mail.cloyne.net \
 --publish 50.0.115.228:25:25/tcp --publish 50.0.115.228:465:465/tcp --publish 50.0.115.228:587:587/tcp \
 --env MAILNAME=mail.cloyne.net \
 --env MY_NETWORKS='10.20.32.0/22 172.17.0.0/16 50.0.115.224/28 127.0.0.0/8' \
 --env ROOT_ALIAS='clonm@bsc.coop,mitar.cloyne@tnode.com' \
 --env MY_DESTINATION='localhost.localdomain, localhost, mail.cloyne.net' \
 --volume /srv/var/hosts:/etc/hosts:ro --volume /srv/var/log/postfix:/var/log/postfix \
 --volume /srv/postfix:/var/spool/postfix --volume /srv/sympa/etc/shared:/etc/sympa/shared \
 cloyne/postfix
