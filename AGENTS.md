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
  - `*.tfstate*`, `.terraform/`
- Do commit:
  - `.terraform.lock.hcl` (locks provider checksums for reproducible CI)
- Prefer GitHub Actions Secrets for credentials.

### 3) Git hygiene
- Small, atomic commits.
- Always use pull requests (no direct pushes to `main`).
- Before committing: `git status --porcelain` + `git diff` + `git diff --staged`.

### 4) Branch protection (required settings)
The `main` branch must have these protections enabled:
- **Require pull request reviews** before merging
- **Require status checks to pass** before merging (at minimum: `PR Plan`)
- **Do not allow bypassing the above settings** (even for admins)
- **Restrict who can push** to the `main` branch

### 5) Change management
- Treat `terraform/` as the source of truth.
- All changes go via PRs; the PR plan comment is the human review surface.
- The CI blocks plans with deletes by default (no accidental destroy).
