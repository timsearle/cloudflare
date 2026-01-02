export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);

    // Look up content from KV store
    const content = await env.WELL_KNOWN.get(pathname);

    if (content === null) {
      return new Response("Not Found", { status: 404 });
    }

    const headers = new Headers();

    // Diagnostic header to prove the Worker executed (can be removed once stable).
    headers.set("X-Well-Known-Worker", "1");

    if (pathname.startsWith("/.well-known/apple-app-site-association")) {
      headers.set("Content-Type", "application/json; charset=utf-8");
    }

    if (pathname.startsWith("/.well-known/atproto-did")) {
      headers.set("Content-Type", "text/plain; charset=utf-8");
    }

    return new Response(content, { status: 200, headers });
  },
};
