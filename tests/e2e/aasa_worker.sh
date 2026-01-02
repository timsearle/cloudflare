#!/usr/bin/env bash
set -euo pipefail

URLS=(
  "https://searle.dev/.well-known/apple-app-site-association"
)

for URL in "${URLS[@]}"; do
  echo "Testing $URL"
  headers=$(mktemp)
  body=$(mktemp)

  http_code=$(curl -sS -L -D "$headers" -o "$body" -w "%{http_code}" "$URL")

  if [[ "$http_code" != "200" ]]; then
    echo "Expected 200, got $http_code"
    cat "$headers" || true
    exit 1
  fi

  if ! awk 'BEGIN{IGNORECASE=1} /^Content-Type:/ {print; if ($0 ~ /application\/json/) found=1} END{exit(found?0:1)}' "$headers"; then
    echo "Expected Content-Type to include application/json"
    cat "$headers" || true
    exit 1
  fi

  if ! jq -e . "$body" >/dev/null; then
    echo "Response body is not valid JSON"
    head -c 400 "$body" | cat
    exit 1
  fi

  echo "JSON OK"

  rm -f "$headers" "$body"
done

echo "AASA worker E2E checks passed"
