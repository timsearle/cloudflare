# Remote state on Cloudflare R2

We use Cloudflare R2 (S3-compatible) for Terraform remote state.

## Prerequisites
- An R2 bucket dedicated to Terraform state (recommended: separate from other data).
- An R2 access key pair (Access Key ID + Secret Access Key) with permissions to read/write objects in that bucket.

## Local bootstrap (safe workflow)
1) Ensure local adoption is no-op:
   ```bash
   ./scripts/cf-adopt-dns.sh
   ```
   This should print `No changes`.

2) Create `terraform/backend.r2.hcl` from the example:
   ```bash
   cp terraform/backend.r2.hcl.example terraform/backend.r2.hcl
   ```

3) Export R2 credentials (do not commit):
   ```bash
   export AWS_ACCESS_KEY_ID="..."
   export AWS_SECRET_ACCESS_KEY="..."
   ```

4) Migrate local state to R2:
   ```bash
   # NOTE: do NOT add -reconfigure here; Terraform errors if you combine it with -migrate-state.
   terraform -chdir=terraform init -migrate-state -force-copy -backend-config=backend.r2.hcl
   ```

5) Re-verify no-op plan:
   ```bash
   terraform -chdir=terraform plan
   ```

References:
- Cloudflare Terraform remote backend docs: https://developers.cloudflare.com/terraform/advanced-topics/remote-backend/
- Cloudflare R2 pricing: https://developers.cloudflare.com/r2/pricing/
