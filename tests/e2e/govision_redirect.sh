#!/usr/bin/env bash
set -euo pipefail

# Test that govision.searle.dev and searle.dev/govision redirect to govision.app

echo "Testing govision.searle.dev redirect"

# Test root redirect
http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-redirs 0 "https://govision.searle.dev")
redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" --max-redirs 0 "https://govision.searle.dev")

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://govision.app/" ]]; then
  echo "Expected redirect to https://govision.app/, got $redirect_url"
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

# Test path preservation (e.g., /privacy/ should redirect to govision.app/privacy/)
http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-redirs 0 "https://govision.searle.dev/privacy/")
redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" --max-redirs 0 "https://govision.searle.dev/privacy/")

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect for /privacy/, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://govision.app/privacy/" ]]; then
  echo "Expected redirect to https://govision.app/privacy/, got $redirect_url"
  exit 1
fi

echo "Path preservation OK: /privacy/ -> $redirect_url"

# Test searle.dev/govision redirects to govision.app
echo "Testing searle.dev/govision redirect"

http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-redirs 0 "https://searle.dev/govision/")
redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" --max-redirs 0 "https://searle.dev/govision/")

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect for searle.dev/govision/, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://govision.app/" ]]; then
  echo "Expected redirect to https://govision.app/, got $redirect_url"
  exit 1
fi

echo "searle.dev/govision/ redirect OK: $http_code -> $redirect_url"

# Test searle.dev/govision/privacy/ redirects correctly
http_code=$(curl -s -o /dev/null -w "%{http_code}" --max-redirs 0 "https://searle.dev/govision/privacy/")
redirect_url=$(curl -s -o /dev/null -w "%{redirect_url}" --max-redirs 0 "https://searle.dev/govision/privacy/")

if [[ "$http_code" != "301" ]]; then
  echo "Expected 301 redirect for searle.dev/govision/privacy/, got $http_code"
  exit 1
fi

if [[ "$redirect_url" != "https://govision.app/privacy/" ]]; then
  echo "Expected redirect to https://govision.app/privacy/, got $redirect_url"
  exit 1
fi

echo "searle.dev/govision/privacy/ redirect OK: $http_code -> $redirect_url"

echo "GoVision redirect E2E checks passed"
