# cloudflare

Terraform + GitHub Actions management for Cloudflare DNS (migrating from click-ops **without changing live DNS**).

## Project rules (non-negotiable)
- **Zero-downtime / no DNS changes during migration**: the first `terraform apply` must be a no-op (or explicitly reviewed/approved deltas only).
- **No secrets or state committed**: Cloudflare API tokens, R2 credentials, and any `*.tfstate` must never enter git (snapshots live under `inventory/` which is ignored).
- **Plan-first workflow**: implementation starts only after `TICKETS.md` / `roadmap.md` are reviewed and agreed.

## Planning docs
- [AGENTS.md](./AGENTS.md)
- [roadmap.md](./roadmap.md)
- [TICKETS.md](./TICKETS.md)

## State backend
- [docs/r2-backend.md](./docs/r2-backend.md)
