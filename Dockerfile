FROM cloyne/runit

MAINTAINER Mitar <mitar.docker@tnode.com>

EXPOSE 25/tcp 465/tcp 587/tcp

# It has to be first so that /etc/aliases is available at postfix installation
COPY ./etc /etc

RUN apt-get update -q -q && \
 echo postfix postfix/main_mailer_type string "'Internet Site'" | debconf-set-selections && \
 echo postfix postfix/mynetworks string "192.168.0.0/16 172.17.0.0/16 127.0.0.0/8" | debconf-set-selections && \
 echo postfix postfix/mailname string temporary.example.com | debconf-set-selections && \
 apt-get install postfix --yes --force-yes && \
 postconf -e mydestination="localhost.localdomain, localhost" && \
 postconf -e smtpd_banner='$myhostname ESMTP $mail_name' && \
 postconf -# myhostname && \
 apt-get install rsyslog --no-install-recommends --yes --force-yes && \
 sed -i 's/\/var\/log\/mail/\/var\/log\/postfix\/mail/' /etc/rsyslog.conf
