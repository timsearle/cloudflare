// Proxy worker for altilium.app
// Fetches content from searle.dev/altilium and serves it at altilium.app
// Rewrites URLs in HTML responses to work correctly on altilium.app

export default {
  async fetch(request) {
    const url = new URL(request.url);
    
    // Map altilium.app/* to searle.dev/altilium/* (except assets which are at root)
    let targetPath;
    if (url.pathname.startsWith("/assets/")) {
      // Assets are served from searle.dev root
      targetPath = url.pathname;
    } else {
      targetPath = url.pathname === "/" ? "/altilium/" : `/altilium${url.pathname}`;
    }
    const targetUrl = `https://searle.dev${targetPath}${url.search}`;
    
    // Create new headers for the origin request
    // Add marker header so redirect rules can skip worker requests
    const originHeaders = new Headers(request.headers);
    originHeaders.set("X-Altilium-Proxy", "1");
    
    // Fetch from origin
    const response = await fetch(targetUrl, {
      method: request.method,
      headers: originHeaders,
      redirect: "manual",
    });
    
    // Clone response with modified headers
    const newHeaders = new Headers(response.headers);
    newHeaders.set("X-Proxy-Worker", "altilium-app");
    
    // Handle redirects - rewrite them to stay on altilium.app
    if (response.status >= 300 && response.status < 400) {
      const location = response.headers.get("Location");
      if (location) {
        const locationUrl = new URL(location, targetUrl);
        if (locationUrl.hostname === "searle.dev" && locationUrl.pathname.startsWith("/altilium")) {
          // Rewrite redirect to altilium.app
          const newPath = locationUrl.pathname.replace(/^\/altilium/, "") || "/";
          newHeaders.set("Location", `https://altilium.app${newPath}${locationUrl.search}`);
        }
      }
    }
    
    // For HTML responses, rewrite URLs
    const contentType = response.headers.get("Content-Type") || "";
    if (contentType.includes("text/html") && response.status === 200) {
      let html = await response.text();
      
      // Rewrite /altilium/privacy/ links to /privacy/
      html = html.replace(/href="\/altilium\/privacy\/"/g, 'href="/privacy/"');
      html = html.replace(/href='\/altilium\/privacy\/'/g, "href='/privacy/'");
      
      // Rewrite og:url and canonical URLs
      html = html.replace(/https:\/\/www\.searle\.dev\/altilium\//g, "https://altilium.app/");
      html = html.replace(/https:\/\/searle\.dev\/altilium\//g, "https://altilium.app/");
      
      // Update og:image to absolute URL (assets stay on searle.dev)
      html = html.replace(
        /content="https:\/\/www\.searle\.dev\/assets\/altilium\//g,
        'content="https://searle.dev/assets/altilium/'
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
