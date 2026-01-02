export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);

    // Map URL paths to KV keys (KV keys avoid slashes due to provider bug)
    const keyMap = {
      "/.well-known/apple-app-site-association": "apple-app-site-association",
      "/.well-known/atproto-did": "atproto-did",
    };

    const kvKey = keyMap[pathname];
    if (!kvKey) {
      return new Response("Not Found", { status: 404 });
    }

    const content = await env.WELL_KNOWN.get(kvKey);
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
