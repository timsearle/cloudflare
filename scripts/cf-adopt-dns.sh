#!/usr/bin/env bash
set -euo pipefail

ZONE_NAME="${ZONE_NAME:-searle.dev}"
ZONE_ID="${ZONE_ID:-ee4724648879ff94b352fe5587800062}"
INVENTORY_DIR="${INVENTORY_DIR:-}"

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "error: CLOUDFLARE_API_TOKEN is not set" >&2
  exit 2
fi

if [[ -z "${INVENTORY_DIR}" ]]; then
  INVENTORY_DIR="$(ls -1dt "inventory/${ZONE_NAME}"/* | head -n1)"
fi

RECORDS_JSON="${INVENTORY_DIR}/dns-records.all.json"
if [[ ! -f "${RECORDS_JSON}" ]]; then
  echo "error: ${RECORDS_JSON} not found" >&2
  exit 3
fi

echo "Importing records from ${INVENTORY_DIR}" >&2

export TF_VAR_cloudflare_api_token="${CLOUDFLARE_API_TOKEN}"

terraform -chdir=terraform init -input=false

while read -r addr import_id; do
  terraform -chdir=terraform import -input=false "${addr}" "${import_id}" >/dev/null
  echo "Imported ${addr}" >&2
done < <(
  python3 - <<'PY' "${RECORDS_JSON}" "${ZONE_ID}"
import json, sys
records_path, zone_id = sys.argv[1], sys.argv[2]
with open(records_path) as f:
    records = json.load(f)
for r in records:
    rid = r['id']
    addr = f"cloudflare_dns_record.record_{rid}"
    import_id = f"{zone_id}/{rid}"
    print(addr + " " + import_id)
PY
)

echo "Running plan (expecting no changes)..." >&2
terraform -chdir=terraform plan -input=false
