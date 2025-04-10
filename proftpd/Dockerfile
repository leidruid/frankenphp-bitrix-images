FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y proftpd-basic proftpd-mod-sftp openssh-client ftpasswd && \
    mkdir -p /etc/proftpd /var/log/proftpd /app && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

COPY proftpd.conf /etc/proftpd/proftpd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]