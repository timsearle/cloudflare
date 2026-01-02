#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
from datetime import datetime

def latest_inventory_dir(zone_name: str) -> str:
    base = f"inventory/{zone_name}"
    if not os.path.isdir(base):
        raise SystemExit(f"error: {base} does not exist; run ./scripts/cf-export-zone.sh first")
    entries = [os.path.join(base, d) for d in os.listdir(base)]
    entries = [d for d in entries if os.path.isdir(d)]
    if not entries:
        raise SystemExit(f"error: no snapshots under {base}")
    return sorted(entries, reverse=True)[0]

def tf_record_name(fqdn: str, zone_name: str) -> str:
    if fqdn == zone_name:
        return "@"
    suffix = "." + zone_name
    if fqdn.endswith(suffix):
        return fqdn[: -len(suffix)]
    return fqdn

def hcl_string(s: str) -> str:
    return json.dumps(s)

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--zone-name", default="searle.dev")
    ap.add_argument("--inventory-dir", default=None)
    ap.add_argument("--out", default="terraform/dns_records.tf")
    args = ap.parse_args()

    inv_dir = args.inventory_dir or latest_inventory_dir(args.zone_name)
    records_path = os.path.join(inv_dir, "dns-records.all.json")

    with open(records_path) as f:
        records = json.load(f)

    lines = []
    lines.append(f"# Generated from {inv_dir} — do not hand-edit\n")

    for r in sorted(records, key=lambda x: (x.get("type", ""), x.get("name", ""), x.get("id", ""))):
        rid = r["id"]
        addr = f"record_{rid}"
        name = tf_record_name(r["name"], args.zone_name)
        rtype = r["type"]
        content = r.get("content", "")
        ttl = r.get("ttl")
        proxied = r.get("proxied")
        proxiable = r.get("proxiable")
        priority = r.get("priority")
        comment = r.get("comment")

        lines.append(f'resource "cloudflare_dns_record" "{addr}" {{')
        lines.append('  zone_id = var.zone_id')
        lines.append(f'  name    = {hcl_string(name)}')
        lines.append(f'  type    = {hcl_string(rtype)}')
        lines.append(f'  content = {hcl_string(content)}')
        if ttl is not None:
            lines.append(f'  ttl     = {ttl}')
        if priority is not None:
            lines.append(f'  priority = {priority}')
        if proxiable is True and proxied is not None:
            lines.append(f'  proxied = {str(bool(proxied)).lower()}')
        if comment:
            lines.append(f'  comment = {hcl_string(comment)}')

        lines.append('  lifecycle {')
        lines.append('    prevent_destroy = true')
        lines.append('  }')
        lines.append('}')
        lines.append('')

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as f:
        f.write("\n".join(lines))

    print(f"wrote {args.out} ({len(records)} records)")

if __name__ == "__main__":
    main()
