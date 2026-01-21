#!/usr/bin/env bash
set -euo pipefail

# Test that govision.app proxies to searle.dev/govision content

echo "Testing govision.app proxy"

# Test root returns 200
http_code=$(curl -sS -o /dev/null -w "%{http_code}" "https://govision.app")

if [[ "$http_code" != "200" ]]; then
  echo "Expected 200 for root, got $http_code"
  exit 1
fi

echo "Root OK: $http_code"

# Test /privacy returns 200
http_code=$(curl -sS -o /dev/null -w "%{http_code}" "https://govision.app/privacy")

if [[ "$http_code" != "200" ]]; then
  echo "Expected 200 for /privacy, got $http_code"
  exit 1
fi

echo "/privacy OK: $http_code"

# Test www.govision.app also works
http_code=$(curl -sS -o /dev/null -w "%{http_code}" -L "https://www.govision.app")

if [[ "$http_code" != "200" ]]; then
  echo "Expected 200 for www.govision.app, got $http_code"
  exit 1
fi

echo "www.govision.app OK: $http_code"

# Verify content comes from the right place (check for GoVision branding)
if ! curl -sS "https://govision.app" | grep -qi "govision"; then
  echo "Expected page to contain 'govision' content"
  exit 1
fi

echo "Content check OK"

echo "govision.app E2E checks passed"
