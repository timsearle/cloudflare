#!/usr/bin/env bash
set -euo pipefail

# Test that searle.dev/altilium redirects to altilium.app

echo "Testing searle.dev/altilium redirect"

# Test searle.dev/altilium redirects to altilium.app
http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-redirs 0 "https://searle.dev/altilium/")
redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" --max-redirs 0 "https://searle.dev/altilium/")

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect for searle.dev/altilium/, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://altilium.app/" ]]; then
  echo "Expected redirect to https://altilium.app/, got $redirect_url"
  exit 1
fi

echo "searle.dev/altilium/ redirect OK: $http_code -> $redirect_url"

# Test that following the redirect reaches the landing page
final_code=$(curl -sS -o /dev/null -w "%{http_code}" -L "https://searle.dev/altilium/")

if [[ "$final_code" != "200" ]]; then
  echo "Expected 200 after redirect, got $final_code"
  exit 1
fi

echo "Final response OK: $final_code"

# Test searle.dev/altilium/privacy/ redirects correctly
http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-redirs 0 "https://searle.dev/altilium/privacy/")
redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" --max-redirs 0 "https://searle.dev/altilium/privacy/")

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect for searle.dev/altilium/privacy/, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://altilium.app/privacy/" ]]; then
  echo "Expected redirect to https://altilium.app/privacy/, got $redirect_url"
  exit 1
fi

echo "searle.dev/altilium/privacy/ redirect OK: $http_code -> $redirect_url"

echo "Altilium redirect E2E checks passed"
