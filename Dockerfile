FROM cloyne/runit

MAINTAINER Mitar <mitar.docker@tnode.com>

EXPOSE 25/tcp 465/tcp 587/tcp

COPY ./etc/aliases /etc/aliases

# We have to start and stop postfix first through init.d to populate
# postfix spool directory for chroot in which postfix is running

RUN apt-get update -q -q && \
 /bin/echo -e postfix postfix/main_mailer_type string "'Internet Site'" | debconf-set-selections && \
 /bin/echo -e postfix postfix/mynetworks string "172.17.0.0/16 127.0.0.0/8" | debconf-set-selections && \
 /bin/echo -e postfix postfix/mailname string temporary.example.com | debconf-set-selections && \
 apt-get install postfix --yes --force-yes && \
 postconf -e mydestination="localhost.localdomain, localhost" && \
 postconf -e smtpd_banner='$myhostname ESMTP $mail_name' && \
 postconf -# myhostname && \
 apt-get install rsyslog --no-install-recommends --yes --force-yes && \
 sed -i 's/\/var\/log\/mail/\/var\/log\/postfix\/mail/' /etc/rsyslog.conf && \
 mkdir /etc/service/postfix && \
 /bin/echo -e '#!/bin/bash -e' > /etc/service/postfix/run && \
 /bin/echo -e "if [ \"\$MAILNAME\" ]; then echo \"\$MAILNAME\" > /etc/mailname; fi" >> /etc/service/postfix/run && \
 /bin/echo -e "if [ \"\$MY_NETWORKS\" ]; then postconf -e mynetworks=\"\$MY_NETWORKS\"; fi" >> /etc/service/postfix/run && \
 /bin/echo -e "if [ \"\$ROOT_ALIAS\" ]; then sed -i '/^root:/d' /etc/aliases; echo \"root: \$ROOT_ALIAS\" >> /etc/aliases; newaliases; fi" >> /etc/service/postfix/run && \
 /bin/echo -e '/etc/init.d/postfix start' >> /etc/service/postfix/run && \
 /bin/echo -e '/etc/init.d/postfix abort' >> /etc/service/postfix/run && \
 /bin/echo -e 'exec /usr/lib/postfix/master -c /etc/postfix -d 2>&1' >> /etc/service/postfix/run && \
 chown root:root /etc/service/postfix/run && \
 chmod 755 /etc/service/postfix/run && \
 mkdir /etc/service/rsyslog && \
 /bin/echo -e '#!/bin/sh' > /etc/service/rsyslog/run && \
 /bin/echo -e 'exec /usr/sbin/rsyslogd -n -c5 2>&1' >> /etc/service/rsyslog/run && \
 chown root:root /etc/service/rsyslog/run && \
 chmod 755 /etc/service/rsyslog/run
