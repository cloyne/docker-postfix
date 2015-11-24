FROM cloyne/runit

MAINTAINER Mitar <mitar.docker@tnode.com>

EXPOSE 25/tcp 465/tcp 587/tcp

# It has to be first so that /etc/aliases is available at postfix installation
COPY ./etc /etc

# We disable IPv6 for now, IPv6 is available in Docker
# even if the host does not have IPv6 connectivity
RUN apt-get update -q -q && \
 echo postfix postfix/main_mailer_type string "'Internet Site'" | debconf-set-selections && \
 echo postfix postfix/mynetworks string "172.17.0.0/16 127.0.0.0/8" | debconf-set-selections && \
 echo postfix postfix/mailname string temporary.example.com | debconf-set-selections && \
 apt-get install postfix adduser openssh-client --yes --force-yes && \
 postconf -e mydestination="localhost.localdomain, localhost" && \
 postconf -e smtpd_banner='$myhostname ESMTP $mail_name' && \
 postconf -# myhostname && \
 postconf -e inet_protocols=ipv4 && \
 adduser --system --group mailpipe --no-create-home --home /nonexistent && \
 apt-get install rsyslog --no-install-recommends --yes --force-yes && \
 sed -i 's/\/var\/log\/mail/\/var\/log\/postfix\/mail/' /etc/rsyslog.conf && \
 cat /etc/postfix/master.cf.append >> /etc/postfix/master.cf && \
 cat /etc/postfix/main.cf.append >> /etc/postfix/main.cf && \
 postmap /etc/postfix/recipient_canonical
