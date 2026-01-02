// Placeholder file for Worker `empty-haze-02db`.
//
// During initial adoption we ignore script content drift (see workers_aasa.tf)
// to avoid any risk of changing behaviour.
//
// Follow-up: once the Cloudflare API token has the correct Workers Scripts
// permissions, we can fetch the exact current script and commit it here,
// then remove ignore_changes to fully manage the script via Terraform.

export default {
  async fetch() {
    return new Response("worker content managed elsewhere (placeholder)", {
      status: 500,
    });
  },
};
