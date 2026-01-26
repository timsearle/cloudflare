#!/bin/bash
set -euo pipefail

if [[ -n "${TF_DATA_DIR:-}" ]]; then
  printf "TF_DATA_DIR is already set to: %s\n" "${TF_DATA_DIR}"
  exit 0
fi

TF_DATA_DIR="${PWD}/.terraform-data"
mkdir -p "$TF_DATA_DIR"
printf "export TF_DATA_DIR=\"%s\"\n" "${TF_DATA_DIR}"
printf "Terraform data dir set (add to shell profile if desired).\n"
