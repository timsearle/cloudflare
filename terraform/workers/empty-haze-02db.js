export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);

    const res = await env.ASSETS.fetch(request);

    if (!res.ok) {
      return res;
    }

    const headers = new Headers(res.headers);

    // Diagnostic header to prove the Worker executed (can be removed once stable).
    headers.set("X-Well-Known-Worker", "1");

    if (pathname.startsWith("/.well-known/apple-app-site-association")) {
      headers.set("Content-Type", "application/json; charset=utf-8");
      headers.set("Content-Disposition", "inline");
    }

    if (pathname.startsWith("/.well-known/atproto-did")) {
      headers.set("Content-Type", "text/plain; charset=utf-8");
      headers.set("Content-Disposition", "inline");
    }

    return new Response(res.body, { status: res.status, statusText: res.statusText, headers });
  },
};
