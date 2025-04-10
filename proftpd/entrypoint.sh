#!/bin/bash
set -e

USER_FILE=/etc/proftpd/ftpasswd.users
GROUP_FILE=/etc/proftpd/ftpasswd.groups

USER=${SFTP_USER:-appuser}
PASSWORD=${SFTP_PASSWORD:-AppUserPassword}

if [[ -z "$SFTP_USER" || -z "$SFTP_PASSWORD" ]]; then
  echo "SFTP_USER or SFTP_PASSWORD is not set. Will use default user appuser:AppUserPassword."
fi

# UID/GID по умолчанию
USER_ID=${SFTP_UID:-1000}
GROUP_ID=${SFTP_GID:-1000}

# Создание пользователя и группы
ftpasswd --passwd --name="$USER" --uid="$USER_ID" --gid="$GROUP_ID" \
         --home=/app --shell=/bin/false --file="$USER_FILE" --stdin <<EOF
$PASSWORD
EOF

echo "$USER:x:$GROUP_ID:" > "$GROUP_FILE"

chmod 640 "$USER_FILE" "$GROUP_FILE"

exec /usr/sbin/proftpd -n
