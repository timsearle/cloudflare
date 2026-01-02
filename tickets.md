# Tickets

## In Progress

## TODO

## Done
- [x] Deploy Cloudflare-side `/.well-known` static responses (AASA + atproto) and verify in prod
  - Switched from Worker Assets to KV storage (Assets don't work with Routes)
- [x] Remove `.well-known` from blog repo after Cloudflare is live (PR #251 merged)
- [x] Add Workers route(s) for `/.well-known/atproto-did`
- [x] Update E2E checks to verify both endpoints and correct Content-Type
- [x] Identify root cause: Worker Static Assets incompatible with Worker Routes
