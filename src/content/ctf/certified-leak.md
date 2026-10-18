---
title: Certified Leak
summary: A "clean" company website hides a forgotten host. Certificate Transparency logs and the Wayback Machine reveal what they forgot to take down.
category: OSINT
tags: [Certificate Transparency, crt.sh, Wayback Machine, Recon]
order: 1
flagFormat: CYBLTZ2026{...}
flagSalt: 9e0500643a9a49e920c5611de92a482d
flagHash: 91f218e6034c7776102987974b1c7da81a29bb873c9a9cc8fa2edb30d045f5e8
---

## Challenge

> Northwind Logistics keeps telling everyone how buttoned-up they are. An anonymous tip says otherwise: *"They're not as careful as they claim. Check what they forgot to take down."*
>
> You're given one thing — their public domain. Their website is clean. Find the leak.

**Entry point given to players:** `northwind-logistics.xyz` (the public site only). No files are distributed.

## Hints

<details>
<summary>Hint 1</summary>

The public site is clean, but every HTTPS certificate a company has ever requested is a matter of public record.

</details>

<details>
<summary>Hint 2</summary>

crt.sh (or Censys / Cert Spotter). Read *every* name in the list, not just the obvious `www` / `mail` ones.

</details>

<details>
<summary>Hint 3</summary>

The interesting host is offline now, but offline doesn't mean it's gone.

</details>
