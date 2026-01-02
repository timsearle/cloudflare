const AASA = {
  applinks: {
    apps: [],
    details: [
      {
        appID: "AFZ4443Y2P.dev.searle.batterykit",
        components: [{ "/": "/altilium/" }],
      },
    ],
  },
};

const ATPROTO_DID = "did:plc:lvgmshavsls4sawd672jly3n\n";

export default {
  async fetch(request) {
    const { pathname } = new URL(request.url);

    if (pathname === "/.well-known/apple-app-site-association") {
      return new Response(JSON.stringify(AASA), {
        status: 200,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Content-Disposition": "inline",
          "Cache-Control": "public, max-age=300",
        },
      });
    }

    if (pathname === "/.well-known/atproto-did") {
      return new Response(ATPROTO_DID, {
        status: 200,
        headers: {
          "Content-Type": "text/plain; charset=utf-8",
          "Content-Disposition": "inline",
          "Cache-Control": "public, max-age=300",
        },
      });
    }

    return new Response("Not Found", { status: 404 });
  },
};
