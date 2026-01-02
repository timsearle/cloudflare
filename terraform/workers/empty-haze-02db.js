export default {
  async fetch(request, env, ctx) {
    const res = await fetch(request);
    const headers = new Headers(res.headers);
    headers.set("Content-Type", "application/json; charset=utf-8");
    headers.set("Content-Disposition", "inline");
    return new Response(res.body, { status: res.status, statusText: res.statusText, headers });
  }
}
