#!/bin/bash -e

# A script for running this image at the Cloyne deployment. See the README file for details.
# Moreover, it uses tozd/hosts for service discovery and mounts its volume (/srv/var/hosts).

mkdir -p /srv/var/log/postfix
mkdir -p /srv/postfix
mkdir -p /srv/sympa/etc/shared

docker stop mail || true
sleep 1
docker rm mail || true
sleep 1
docker run --detach=true --restart=always --name mail --hostname mail.cloyne.net --publish 64.62.133.44:25:25/tcp --publish 64.62.133.44:465:465/tcp --publish 64.62.133.44:587:587/tcp --env MAILNAME=mail.cloyne.net --env MY_NETWORKS='10.20.32.0/22 172.17.0.0/16 64.62.133.40/29 127.0.0.0/8' --env ROOT_ALIAS='clonm@bsc.coop,mitar.cloyne@tnode.com' --env MY_DESTINATION='localhost.localdomain, localhost, mail.cloyne.net' --volume /srv/var/hosts:/etc/hosts:ro --volume /srv/var/log/postfix:/var/log/postfix --volume /srv/postfix:/var/spool/postfix --volume /srv/sympa/etc/shared:/etc/sympa/shared cloyne/postfix
