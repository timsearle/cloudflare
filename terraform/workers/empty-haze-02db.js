export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);

    const res = await env.ASSETS.fetch(request);

    if (!res.ok) {
      return res;
    }

    const headers = new Headers(res.headers);

    if (pathname === "/.well-known/apple-app-site-association") {
      headers.set("Content-Type", "application/json; charset=utf-8");
      headers.set("Content-Disposition", "inline");
    }

    if (pathname === "/.well-known/atproto-did") {
      headers.set("Content-Type", "text/plain; charset=utf-8");
      headers.set("Content-Disposition", "inline");
    }

    return new Response(res.body, { status: res.status, statusText: res.statusText, headers });
  },
};
