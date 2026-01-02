# E2E tests

These tests perform lightweight external checks against searle.dev to ensure critical endpoints keep working.

- `aasa_worker.sh`: verifies `/.well-known/apple-app-site-association` (JSON) and `/.well-known/atproto-did` (text) return HTTP 200 with correct `Content-Type`.
