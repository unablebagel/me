# OpenWrt deployment and Quick Tunnel

This repository produces two builds from `main`:

- GitHub Pages output under `/me`
- a root-path router bundle published as an immutable GitHub Release named `deploy-<commit>`

The router never accepts an inbound deployment connection. Every five minutes it makes outbound HTTPS requests to GitHub, downloads the newest bundle, verifies its manifest and SHA-256 checksum, extracts into a staging directory, atomically changes the `current` symlink, and performs a local HTTP health check. A failed health check restores the previous symlink. `me-deploy rollback` swaps back to the retained previous release.

GitHub also records a build provenance attestation for `site.tar.gz`. The router is small enough that the local agent verifies the release tag, repository, commit, monotonic workflow run ID, archive size, member paths, and SHA-256 checksum instead of installing the GitHub CLI.

## Router prerequisites

Do not expose SSH, LuCI, or port 8080 on the WAN. Keep the existing portfolio listener bound only to the LAN address `192.168.2.1:8080`. The only public path should be the outbound Cloudflare Tunnel process targeting that LAN-only listener from the router itself.

Before installation, inspect these values over a trusted LAN session:

```sh
ubus call system board
df -h
free
command -v uclient-fetch jsonfilter sha256sum tar
uci show uhttpd
ss -lntp
```

The deployer expects the site-serving uHTTPd instance on port 8080 to use `/srv/me/current` as its document root. Back up `/etc/config/uhttpd` before changing only that instance. Do not change the LuCI listener or firewall zones.

Copy the `openwrt` directory to a temporary router directory, then run:

```sh
chmod 0755 /tmp/openwrt/install-deployer.sh /tmp/openwrt/me-deploy
/tmp/openwrt/install-deployer.sh
/usr/libexec/me-deploy check
/usr/libexec/me-deploy status
```

If the first health check fails, the new release is not left active. Useful recovery commands are:

```sh
/usr/libexec/me-deploy rollback
logread -e me-deploy
```

## Cloudflare Quick Tunnel

The WHW03 V2 uses the OpenWrt `arm_cortex-a7_neon-vfpv4` package architecture. Cloudflare's `cloudflared-linux-armhf` build is the matching 32-bit ARM hard-float variant. The installer is pinned to Cloudflare `2026.10.1` and verifies the published SHA-256 digest before executing or installing the binary. It also requires at least 80 MiB of writable overlay space.

After inspecting the router's available space and installed libraries, run:

```sh
chmod 0755 /tmp/openwrt/install-cloudflared.sh
/tmp/openwrt/install-cloudflared.sh
logread -e cloudflared
```

The log shows the assigned `https://<random>.trycloudflare.com` URL. It is temporary, has no uptime guarantee, and changes whenever Cloudflare assigns a new tunnel after the process restarts. No Cloudflare account or domain is required.

To stop public access while keeping the LAN site available:

```sh
/etc/init.d/cloudflared-quick stop
/etc/init.d/cloudflared-quick disable
```
