# AGENTS.md

This repository will manage Cloudflare DNS via Terraform + GitHub Actions.

## Mission
Migrate an existing Cloudflare DNS configuration from click-ops to IaC **without breaking DNS** and with a verifiable, reversible migration path.

## Working agreements

### 1) Safety first (DNS must not change during migration)
- The migration approach is **import-then-verify**:
  1) capture a full inventory of the current zone(s)
  2) write Terraform configuration to match reality
  3) `terraform import` existing resources into state
  4) prove `terraform plan` is **0 changes** before any apply
- Prefer `terraform plan` and `terraform apply -refresh-only` while validating.
- Add guard rails where appropriate (e.g. `lifecycle { prevent_destroy = true }` for records; and CI rules to block destructive plans).

### 2) Secrets/state hygiene
- Never commit:
  - Cloudflare API tokens
  - Cloudflare R2 access keys
  - `*.tfstate*`, `.terraform/`, `.terraform.lock.hcl` (decision pending)
- Prefer GitHub Actions Secrets for credentials.

### 3) Git hygiene
- Small, atomic commits.
- Before committing: `git status --porcelain` + `git diff` + `git diff --staged`.

### 4) No implementation until plan review
- Update `TICKETS.md` / `roadmap.md` first.
- Do not create real Terraform resources or workflows until the plan is approved.
