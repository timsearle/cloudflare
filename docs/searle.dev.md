# searle.dev — Cloudflare DNS inventory

This document is generated/maintained from a read-only export of the live zone to support a **no-change** Terraform import.

## How to refresh the snapshot (local; not committed)
Create a **read-only** Cloudflare API token and run:

```bash
export CLOUDFLARE_API_TOKEN="..." # do NOT commit
./scripts/cf-export-zone.sh
```

Snapshots are written under `inventory/searle.dev/<timestamp>/` and are ignored by git.

## Current live snapshot (20260101T202906Z)
- Snapshot time (UTC): `20260101T202906Z`
- Zone: `searle.dev` (`ee4724648879ff94b352fe5587800062`)
- Cloudflare nameservers: `alexis.ns.cloudflare.com`, `ingrid.ns.cloudflare.com`
- DNS record count: **18**
- Record types present: **A(4), CNAME(5), MX(2), NS(4), TXT(3)**
- TTL: **all auto** (`ttl=1` for all records)
- Proxied records: **5** proxied, **13** DNS-only
- Wildcard records: none
- DNSSEC status: `disabled`
- MX priorities present: `10`, `20`

## Notes / migration risks
- **Zone settings inventory incomplete**: `GET /zones/:id/settings` returned `9109 Unauthorized`; if we want to manage zone settings later we’ll need a token with **Zone Settings:Read** (and **Edit** only when applying).
- TTL “auto” handling: Cloudflare represents auto TTL as `1`.
- Proxied vs DNS-only: proxied state must be preserved per record.
- NS records: ensure we don’t accidentally change delegation-related records; they can be sensitive.
- MX ordering: preserve priorities (currently `10` and `20`).
- Record comments: if any records rely on comments, ensure import/provider support doesn’t cause drift.

## Terraform adoption status (local)
- Terraform provider pinned to Cloudflare provider **v5**.
- `./scripts/cf-adopt-dns.sh` imports existing DNS records into **local** Terraform state and validates the result with `terraform plan`.
- Result for snapshot `20260101T202906Z`: **No changes** (safe point to proceed to remote state bootstrap).
