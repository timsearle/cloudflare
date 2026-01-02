# Tickets

## In Progress
- [ ] Deploy Cloudflare-side `/.well-known` static responses (AASA + atproto) and verify in prod
  - PR #25: Switch from Worker Assets to KV storage (Assets don't work with Routes)

## TODO
- [ ] Remove `.well-known` from blog repo after Cloudflare is live

## Done
- [x] Add Workers route(s) for `/.well-known/atproto-did`
- [x] Update E2E checks to verify both endpoints and correct Content-Type
- [x] Identify root cause: Worker Static Assets incompatible with Worker Routes
