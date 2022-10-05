FROM clonm/postfix

VOLUME /etc/sympa/shared
VOLUME /etc/postfix/sasl

RUN apt-get update -q -q && \
 apt-get install adduser openssh-client --yes --force-yes && \
 adduser --system --group mailpipe --no-create-home --home /nonexistent && \
 cp /etc/postfix/main.cf /etc/postfix/main.cf.orig && \
 cp /etc/postfix/master.cf /etc/postfix/master.cf.orig && \
 mkdir -p /etc/service && \
 sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

COPY ./etc/postfix /etc/postfix
COPY ./etc/service/postfix /etc/service/postfix
COPY ./etc/aliases /etc/aliases

# make sure permissions are correct
RUN chown -R postfix:postfix /var/lib/postfix &&\
 find /var/spool/postfix -user 105 -exec chown postfix '{}' '+' &&\
 chown -R postfix:postfix /var/spool/postfix/maildrop /var/spool/postfix/public &&\
 chown -R syslog:adm /var/log/postfix
