#!/usr/bin/env bash
set -euo pipefail

URLS=(
  "https://searle.dev/.well-known/apple-app-site-association"
  "https://searle.dev/.well-known/atproto-did"
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

  if [[ "$URL" == *"apple-app-site-association" ]]; then
    if ! awk '{l=tolower($0)} l ~ /^content-type:/ {print; if (l ~ /application\/json/) found=1} END{exit(found?0:1)}' "$headers"; then
      echo "Expected Content-Type to include application/json"
      cat "$headers" || true
      exit 1
    fi

    if ! jq -e . "$body" >/dev/null; then
      echo "Response body is not valid JSON"
      head -c 400 "$body" | cat
      exit 1
    fi

    echo "AASA JSON OK"
  else
    if ! awk '{l=tolower($0)} l ~ /^content-type:/ {print; if (l ~ /text\/plain/ || l ~ /application\/octet-stream/) found=1} END{exit(found?0:1)}' "$headers"; then
      echo "Expected Content-Type to include text/plain (or application/octet-stream before migration)"
      cat "$headers" || true
      exit 1
    fi

    if ! grep -q '^did:plc:' "$body"; then
      echo "Expected body to be a did:plc: value"
      cat "$body" || true
      exit 1
    fi

    echo "atproto DID OK"
  fi

  rm -f "$headers" "$body"
done

echo "Well-known worker E2E checks passed"
