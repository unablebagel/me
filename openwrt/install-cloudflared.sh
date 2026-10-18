#!/bin/sh
set -eu

SOURCE_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
VERSION='2026.10.1'
ASSET='cloudflared-linux-armhf'
EXPECTED_SHA256='c047e24af9ed956b55d514e3a0e2d8020e9c6d0629c4731c8ec08bd79a29a050'
DOWNLOAD_URL="https://github.com/cloudflare/cloudflared/releases/download/$VERSION/$ASSET"
TEMP_FILE="/tmp/cloudflared.$$.download"
INSTALL_FILE="/usr/bin/.cloudflared.$$.new"

cleanup() {
  rm -f "$TEMP_FILE" "$INSTALL_FILE"
}
trap cleanup EXIT HUP INT TERM

[ "$(id -u)" = '0' ] || { echo 'Run this installer as root on OpenWrt.' >&2; exit 1; }
case "$(uname -m)" in
  armv7l|armv7*) ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

command -v uclient-fetch >/dev/null 2>&1 || { echo 'uclient-fetch is required.' >&2; exit 1; }
command -v sha256sum >/dev/null 2>&1 || { echo 'sha256sum is required.' >&2; exit 1; }
[ -r "$SOURCE_DIR/cloudflared-quick.init" ] || { echo 'Missing cloudflared-quick.init.' >&2; exit 1; }

free_kib="$(df -Pk /overlay | awk 'NR == 2 {print $4}')"
case "$free_kib" in
  ''|*[!0-9]*) echo 'Could not determine free overlay space.' >&2; exit 1 ;;
esac
[ "$free_kib" -ge 81920 ] || {
  echo "At least 80 MiB of free overlay space is required; ${free_kib} KiB is available." >&2
  exit 1
}

uclient-fetch -q -T 120 -O "$TEMP_FILE" "$DOWNLOAD_URL"
actual_sha256="$(sha256sum "$TEMP_FILE" | awk '{print $1}')"
[ "$actual_sha256" = "$EXPECTED_SHA256" ] || {
  echo 'cloudflared checksum verification failed.' >&2
  exit 1
}

chmod 0755 "$TEMP_FILE"
"$TEMP_FILE" version | grep -F "$VERSION" >/dev/null || {
  echo 'Downloaded cloudflared binary did not execute with the expected version.' >&2
  exit 1
}

cp "$TEMP_FILE" "$INSTALL_FILE"
chmod 0755 "$INSTALL_FILE"
mv -f "$INSTALL_FILE" /usr/bin/cloudflared
cp "$SOURCE_DIR/cloudflared-quick.init" /etc/init.d/cloudflared-quick
chmod 0755 /etc/init.d/cloudflared-quick

/etc/init.d/cloudflared-quick enable
/etc/init.d/cloudflared-quick restart
echo 'Quick Tunnel started. Run: logread -e cloudflared'
