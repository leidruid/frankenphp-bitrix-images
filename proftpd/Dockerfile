FROM alpine:latest

RUN apk update && apk add --no-cache \
  proftpd \
  proftpd-mod_sftp \
  proftpd-utils \
  openssh-client \
  openssl \
  bash \
  && rm -rf /var/cache/apk/*

RUN mkdir -p /app \
  && rm -rf /etc/proftpd/* \
  && mkdir -p /run/proftpd \
  && chown proftpd:proftpd /run/proftpd \
  && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
  && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
  && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''

COPY proftpd.conf /etc/proftpd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 2022
ENTRYPOINT ["/entrypoint.sh"]