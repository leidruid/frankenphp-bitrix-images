#!/bin/bash
set -e

USER_FILE=/etc/proftpd/ftpasswd.users
GROUP_FILE=/etc/proftpd/ftpasswd.groups

if [[ -f "$USER_FILE" && -f "$GROUP_FILE" ]]; then
  echo "User and group files already exist. Skipping user creation."
  USER=$(cat /etc/proftpd/ftpasswd.users | cut -d ":" -f1)
else
  USER=${SFTP_USER:-appuser}
  PASSWORD=${SFTP_PASSWORD:-AppUserPassword}

  if [[ -z "$SFTP_USER" || -z "$SFTP_PASSWORD" ]]; then
    echo "SFTP_USER or SFTP_PASSWORD is not set. Will use default user $USER:$PASSWORD"
  fi

  USER_ID=${SFTP_UID:-1000}
  GROUP_ID=${SFTP_GID:-1000}

  ftpasswd --passwd --name="$USER" --uid="$USER_ID" --gid="$GROUP_ID" \
           --home=/app --shell=/bin/false --file="$USER_FILE" --stdin <<< $PASSWORD 2>/dev/null 1>&2

  echo "$USER:x:$GROUP_ID:" > "$GROUP_FILE"
  chmod 640 "$USER_FILE" "$GROUP_FILE"
fi
sed -r "s/SFTP_USER/$USER/g" -i /etc/proftpd.conf
exec /usr/sbin/proftpd -c /etc/proftpd.conf -n
