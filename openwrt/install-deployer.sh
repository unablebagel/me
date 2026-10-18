#!/bin/sh
set -eu

SOURCE_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
CRON_LINE='*/5 * * * * /usr/libexec/me-deploy check >/dev/null 2>&1'

[ "$(id -u)" = '0' ] || { echo 'Run this installer as root on OpenWrt.' >&2; exit 1; }
command -v uclient-fetch >/dev/null 2>&1 || { echo 'uclient-fetch is required.' >&2; exit 1; }
command -v jsonfilter >/dev/null 2>&1 || { echo 'jsonfilter is required.' >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo 'sha256sum is required.' >&2; exit 1; }

mkdir -p /usr/libexec /var/lib/me-deploy /srv/me/releases /etc/crontabs
cp "$SOURCE_DIR/me-deploy" /usr/libexec/me-deploy
chmod 0755 /usr/libexec/me-deploy

if [ ! -e /etc/me-deploy.conf ]; then
  cp "$SOURCE_DIR/me-deploy.conf" /etc/me-deploy.conf
  chmod 0600 /etc/me-deploy.conf
fi

touch /etc/crontabs/root
if ! grep -Fqx "$CRON_LINE" /etc/crontabs/root; then
  cp /etc/crontabs/root "/etc/crontabs/root.bak.$(date +%s)"
  printf '%s\n' "$CRON_LINE" >> /etc/crontabs/root
fi

/etc/init.d/cron restart
echo 'Deployment checker installed. Configure the web root as /srv/me/current before the first deployment.'
