// Placeholder file for Worker `empty-haze-02db`.
//
// In the initial adoption PR we set lifecycle.ignore_changes = all to ensure
// Terraform does not update the live script during adoption.
//
// Follow-up PR: replace this placeholder with the real script source and
// remove ignore_changes so Terraform fully manages the script.

export default {
  async fetch() {
    return new Response("placeholder", { status: 500 });
  },
};
