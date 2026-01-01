# roadmap.md

## Goal
Manage Cloudflare DNS configuration using Terraform with a GitHub Actions pipeline, with a **safe migration** from the existing click-ops setup.

## Guiding principles
- **No change to live DNS during migration**: the first successful end-to-end run must result in a `terraform plan` showing **no changes**.
- **Import, don’t recreate**: existing resources are imported into state.
- **Apply is gated**: automatic planning on PRs; applies require explicit approval.

---

## Phase 0 — Discovery + inventory (no Terraform changes yet)
**Outcome:** we can prove what exists today and have a rollback reference.
- Identify all Cloudflare zones in scope (e.g. `searle.dev`).
- Export current DNS records (and zone metadata) via API into an *uncommitted* local snapshot.
- Current `searle.dev` inventory snapshot (20260101T202906Z):
  - 18 records total: A(4), CNAME(5), MX(2), NS(4), TXT(3)
  - TTL is auto for all records (`ttl=1`)
  - 5 proxied / 13 DNS-only
  - DNSSEC: disabled
- Zone settings export is currently **unauthorized** with our read token; if we later manage zone settings we’ll need **Zone Settings:Read** (and **Edit** only when applying).
- Decide what is in-scope for Terraform initially:
  - DNS records only? (recommended first)
  - Zone settings / page rules / workers routes etc. — later unless required

## Phase 1 — Repo scaffolding + credential model
**Outcome:** we can run `terraform init/plan` locally in a safe way.
- Pin Terraform version.
- Decide provider version + module layout.
- Establish credential strategy:
  - Cloudflare API token with minimum permissions.
  - R2 bucket for Terraform remote state.
- Confirm state-locking approach:
  - Prefer Terraform S3 backend `use_lockfile` (verify R2 compatibility).
  - Add GitHub Actions `concurrency` to prevent parallel applies.

## Phase 2 — Terraform config authored to match reality
**Outcome:** Terraform configuration matches exported inventory.
- Write `cloudflare_record` resources for existing records.
- Normalize data to avoid diffs (TTL auto=1, proxied flags, record comments, priorities, etc.).
- Add guard rails (prevent_destroy on records; CI checks for destructive changes).

## Phase 3 — Import + prove no-op plan
**Outcome:** imported state matches reality; plans show zero changes.
- Import each record into Terraform state.
- Run `terraform plan` repeatedly until **0 changes**.
- Only once stable: migrate state to R2 (if bootstrapped locally), and re-verify **0 changes**.

## Phase 4 — GitHub Actions workflow (plan + gated apply)
**Outcome:** changes are managed through PRs.
- PR workflow: fmt/validate + plan and publish plan summary.
- Main workflow: apply only via manual approval (GitHub Environments) and serialized runs.

## Phase 5 — Operationalize
**Outcome:** ongoing DNS changes are safe and auditable.
- Document common changes (adding records, updating targets, etc.).
- Add runbook: how to rotate credentials, how to recover state, how to do emergency hotfixes.
