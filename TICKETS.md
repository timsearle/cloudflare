# Tickets / Handover

## Current state (2026-01-01)
- Repo scaffolded, plan written.
- **No Terraform / GitHub Actions implementation yet** (awaiting plan review).

---

## What I need from you to complete the project

### Cloudflare scope
1) **Zone(s)** to manage (domain names) and confirmation this is *only* DNS initially.
2) Confirmation whether we should include:
   - DNS records only (recommended first)
   - zone settings (SSL/TLS modes, etc.)
   - page rules / redirects / workers routes (likely out of scope for phase 1)

### Credentials (minimum required)
3) A **Cloudflare API Token** (or willingness for me to guide you creating one) with least privileges, typically:
   - Zone:Read
   - DNS:Read
   - DNS:Edit (needed only when we start applying)
   - (Optional later) Zone Settings:Read/Edit

### Remote state (Cloudflare R2)
4) R2 details:
   - Cloudflare Account ID
   - R2 bucket name for Terraform state
   - R2 access key id + secret (to be stored as GitHub secrets; never committed)
   - Preferred state key path (e.g. `cloudflare/terraform.tfstate`) and whether you want per-zone state.

### GitHub
5) Confirm the GitHub repo should be:
   - `timsearle/cloudflare` (private)
   - default branch `main`
6) Confirm whether you want:
   - required PR reviews
   - GitHub Environment approvals for apply (recommended)

---

## Proposed migration checklist (high-level)
1) Inventory/export current DNS records (snapshot).
2) Author Terraform resources to match the snapshot.
3) Import existing records into Terraform state.
4) Iterate until `terraform plan` shows **no changes**.
5) Configure remote state in R2 and re-verify **no changes**.
6) Add GitHub Actions workflows (plan on PR; gated apply on main).
7) First apply should be a no-op; only then begin managing changes via PRs.

---

## Next tickets (once plan is approved)
- P0: Confirm zone scope + what resources we manage first.
- P1: Decide Terraform version + provider pinning and state-locking approach for R2.
- P2: Build inventory exporter (Cloudflare API) and store snapshot locally (uncommitted).
- P3: Author Terraform config for records + import script/runbook.
- P4: Prove zero-change plan.
- P5: Add GitHub Actions (plan + gated apply) and document secrets.
