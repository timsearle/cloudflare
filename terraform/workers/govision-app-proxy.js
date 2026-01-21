// Proxy worker for govision.app
// Fetches content from searle.dev/govision and serves it at govision.app
// Rewrites URLs in HTML responses to work correctly on govision.app

export default {
  async fetch(request) {
    const url = new URL(request.url);
    
    // Map govision.app/* to searle.dev/govision/* (except assets which are at root)
    let targetPath;
    if (url.pathname.startsWith("/assets/")) {
      // Assets are served from searle.dev root
      targetPath = url.pathname;
    } else {
      targetPath = url.pathname === "/" ? "/govision/" : `/govision${url.pathname}`;
    }
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
    
    // For HTML responses, rewrite URLs
    const contentType = response.headers.get("Content-Type") || "";
    if (contentType.includes("text/html") && response.status === 200) {
      let html = await response.text();
      
      // Rewrite /govision/privacy/ links to /privacy/
      html = html.replace(/href="\/govision\/privacy\/"/g, 'href="/privacy/"');
      html = html.replace(/href='\/govision\/privacy\/'/g, "href='/privacy/'");
      
      // Rewrite og:url and canonical URLs
      html = html.replace(/https:\/\/www\.searle\.dev\/govision\//g, "https://govision.app/");
      html = html.replace(/https:\/\/searle\.dev\/govision\//g, "https://govision.app/");
      
      // Update og:image to absolute URL (assets stay on searle.dev)
      html = html.replace(
        /content="https:\/\/www\.searle\.dev\/assets\/govision\//g,
        'content="https://searle.dev/assets/govision/'
      );
      
      return new Response(html, {
        status: response.status,
        statusText: response.statusText,
        headers: newHeaders,
      });
    }
    
    return new Response(response.body, {
      status: response.status,
      statusText: response.statusText,
      headers: newHeaders,
    });
  },
};
