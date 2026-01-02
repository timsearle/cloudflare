# E2E tests

These tests perform lightweight external checks against searle.dev to ensure critical endpoints keep working.

- `aasa_worker.sh`: verifies `/.well-known/apple-app-site-association` returns HTTP 200 and `Content-Type: application/json`.
