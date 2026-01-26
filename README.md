# cloudflare

Terraform + GitHub Actions management for Cloudflare DNS and Workers.

## Project rules (non-negotiable)
- **No direct pushes to `main`**: all changes go through PRs.
- **No secrets or state committed**: Cloudflare API tokens, R2 credentials, and any `*.tfstate` must never enter git.
- **Plan-first workflow**: PRs generate a plan and comment it on the PR; merge-to-main applies the exact plan artifact produced on `main`.

## What's managed
- **DNS records** for `searle.dev`
- **Worker** (`empty-haze-02db`) serving `/.well-known/*` routes via KV storage
- **KV namespace** (`well-known-content`) storing static content with correct Content-Types

## Docs
- [AGENTS.md](./AGENTS.md)
- [roadmap.md](./roadmap.md)
- [docs/r2-backend.md](./docs/r2-backend.md)

## GitHub Actions
- `Terraform (Cloudflare DNS)`
  - PRs: fmt/validate/plan + PR comment
  - main: plan artifact then apply that exact artifact (gated via GitHub Environment `cloudflare-dns`)
- `Tests (E2E)`
  - nightly at 03:00 UTC
  - post-apply signal (runs only after a successful Terraform run on `main`)

## Required GitHub secrets
- `CLOUDFLARE_API_TOKEN`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (e.g. `WEUR`)

## State backend
- [docs/r2-backend.md](./docs/r2-backend.md)

## Making changes
- Edit Terraform under `terraform/`.
- Keep local state out of the repo root (use `TF_DATA_DIR` or `. scripts/set-terraform-data-dir.sh`).
- Open a PR and review the posted plan comment.
- Merge to `main` to apply (gated by the `cloudflare-dns` environment).
