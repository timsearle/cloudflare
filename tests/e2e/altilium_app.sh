#!/usr/bin/env bash
set -euo pipefail

# Test that altilium.app proxies to searle.dev/altilium content

echo "Testing altilium.app proxy"

# Test root returns 200
http_code=$(curl -sS -o /dev/null -w "%{http_code}" "https://altilium.app")

if [[ "$http_code" != "200" ]]; then
  echo "Expected 200 for root, got $http_code"
  exit 1
fi

echo "Root OK: $http_code"

# Test /privacy returns 200 (follow redirect for trailing slash)
http_code=$(curl -sS -o /dev/null -w "%{http_code}" -L "https://altilium.app/privacy")

if [[ "$http_code" != "200" ]]; then
  echo "Expected 200 for /privacy, got $http_code"
  exit 1
fi

echo "/privacy OK: $http_code"

# Test www.altilium.app also works
http_code=$(curl -sS -o /dev/null -w "%{http_code}" -L "https://www.altilium.app")

if [[ "$http_code" != "200" ]]; then
  echo "Expected 200 for www.altilium.app, got $http_code"
  exit 1
fi

echo "www.altilium.app OK: $http_code"

# Verify content comes from the right place (check for Altilium branding and rewritten URLs)
content=$(curl -s "https://altilium.app")
if ! echo "$content" | grep -qi "altilium"; then
  echo "Expected page to contain 'altilium' content"
  exit 1
fi

if ! echo "$content" | grep -q "https://altilium.app/"; then
  echo "Expected canonical/og:url to point to https://altilium.app/"
  exit 1
fi

echo "Content check OK"

echo "altilium.app E2E checks passed"
