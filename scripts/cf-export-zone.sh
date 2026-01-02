#!/usr/bin/env bash
set -euo pipefail

ZONE_NAME="${ZONE_NAME:-searle.dev}"
OUT_DIR="${OUT_DIR:-inventory/${ZONE_NAME}/$(date -u +%Y%m%dT%H%M%SZ)}"

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "error: CLOUDFLARE_API_TOKEN is not set" >&2
  exit 2
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required" >&2
  exit 2
fi

api() {
  local path="$1"
  curl -sS "https://api.cloudflare.com/client/v4${path}" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json"
}

mkdir -p "${OUT_DIR}"

zone_id="$(
  api "/zones?name=${ZONE_NAME}&status=active" | jq -r '.result[0].id // empty'
)"

if [[ -z "${zone_id}" ]]; then
  echo "error: could not resolve zone id for ${ZONE_NAME}" >&2
  exit 3
fi

echo "Exporting zone ${ZONE_NAME} (${zone_id}) -> ${OUT_DIR}" >&2

api "/zones/${zone_id}" > "${OUT_DIR}/zone.json"
api "/zones/${zone_id}/settings" > "${OUT_DIR}/zone-settings.json"
api "/zones/${zone_id}/dnssec" > "${OUT_DIR}/dnssec.json"

# DNS records (paginated)
page=1
per_page=100
all_records='[]'

while :; do
  resp="$(api "/zones/${zone_id}/dns_records?per_page=${per_page}&page=${page}")"
  echo "${resp}" > "${OUT_DIR}/dns-records.page-${page}.json"

  chunk="$(echo "${resp}" | jq -c '.result // []')"
  all_records="$(jq -cs '.[0] + .[1]' <(echo "${all_records}") <(echo "${chunk}"))"

  total_pages="$(echo "${resp}" | jq -r '.result_info.total_pages // 1')"
  if [[ "${page}" -ge "${total_pages}" ]]; then
    break
  fi
  page=$((page+1))
done

echo "${all_records}" | jq '.' > "${OUT_DIR}/dns-records.all.json"

echo "Done." >&2
