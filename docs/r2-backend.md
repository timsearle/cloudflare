# Remote state on Cloudflare R2

We use Cloudflare R2 (S3-compatible) for Terraform remote state.

## Prerequisites
- Terraform
- `jq`
- An R2 bucket dedicated to Terraform state (recommended: separate from other data).
- An R2 access key pair (Access Key ID + Secret Access Key) with permissions to read/write objects in that bucket.

## Local bootstrap (safe workflow)

1) Create `terraform/backend.r2.hcl` from the example:

```bash
cp terraform/backend.r2.hcl.example terraform/backend.r2.hcl
```

2) Export R2 credentials (do not commit):

```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."

# R2 bucket region (discovered via `aws s3api head-bucket`)
export AWS_REGION="WEUR"
export AWS_DEFAULT_REGION="WEUR"
```

3) Migrate local state to R2:

```bash
# NOTE: do NOT add -reconfigure here; Terraform errors if you combine it with -migrate-state.
terraform -chdir=terraform init -migrate-state -force-copy -backend-config=backend.r2.hcl
```

4) Re-verify no-op plan:

```bash
terraform -chdir=terraform plan
```

