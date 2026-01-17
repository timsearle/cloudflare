#!/usr/bin/env bash
set -euo pipefail

# Test that govision.searle.dev redirects to searle.dev/govision/

echo "Testing govision.searle.dev redirect"

# Test root redirect
response=$(curl -sS -o /dev/null -w "%{http_code} %{redirect_url}" -L --max-redirs 0 "https://govision.searle.dev" 2>&1 || true)
http_code=$(echo "$response" | awk '{print $1}')
redirect_url=$(echo "$response" | awk '{print $2}')

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://searle.dev/govision/" ]]; then
  echo "Expected redirect to https://searle.dev/govision/, got $redirect_url"
  exit 1
fi

echo "Root redirect OK: $http_code -> $redirect_url"

# Test that following the redirect reaches the landing page
final_code=$(curl -sS -o /dev/null -w "%{http_code}" -L "https://govision.searle.dev")

if [[ "$final_code" != "200" ]]; then
  echo "Expected 200 after redirect, got $final_code"
  exit 1
fi

echo "Final response OK: $final_code"

# Test path preservation (e.g., /privacy/ should redirect to /govision/privacy/)
response=$(curl -sS -o /dev/null -w "%{http_code} %{redirect_url}" -L --max-redirs 0 "https://govision.searle.dev/privacy/" 2>&1 || true)
http_code=$(echo "$response" | awk '{print $1}')
redirect_url=$(echo "$response" | awk '{print $2}')

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect for /privacy/, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://searle.dev/govision/privacy/" ]]; then
  echo "Expected redirect to https://searle.dev/govision/privacy/, got $redirect_url"
  exit 1
fi

echo "Path preservation OK: /privacy/ -> $redirect_url"

echo "GoVision redirect E2E checks passed"
