// Proxy worker for govision.app
// Fetches content from searle.dev/govision and serves it at govision.app

export default {
  async fetch(request) {
    const url = new URL(request.url);
    
    // Map govision.app/* to searle.dev/govision/*
    const targetPath = url.pathname === "/" ? "/govision/" : `/govision${url.pathname}`;
    const targetUrl = `https://searle.dev${targetPath}${url.search}`;
    
    // Fetch from origin
    const response = await fetch(targetUrl, {
      method: request.method,
      headers: request.headers,
      redirect: "manual",
    });
    
    // Clone response with modified headers
    const newHeaders = new Headers(response.headers);
    newHeaders.set("X-Proxy-Worker", "govision-app");
    
    // Handle redirects - rewrite them to stay on govision.app
    if (response.status >= 300 && response.status < 400) {
      const location = response.headers.get("Location");
      if (location) {
        const locationUrl = new URL(location, targetUrl);
        if (locationUrl.hostname === "searle.dev" && locationUrl.pathname.startsWith("/govision")) {
          // Rewrite redirect to govision.app
          const newPath = locationUrl.pathname.replace(/^\/govision/, "") || "/";
          newHeaders.set("Location", `https://govision.app${newPath}${locationUrl.search}`);
        }
      }
    }
    
    return new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers: newHeaders,
    });
  },
};
