defmodule OlamWeb.SeoController do
  use OlamWeb, :controller

  def sitemap(conn, _params) do
    # Generate sitemap with current timestamp
    last_modified = DateTime.utc_now() |> DateTime.to_iso8601()

    sitemap_xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
            xmlns:xhtml="http://www.w3.org/1999/xhtml">
      <url>
        <loc>https://niladict.in/</loc>
        <lastmod>#{last_modified}</lastmod>
        <changefreq>daily</changefreq>
        <priority>1.0</priority>
        <xhtml:link rel="alternate" hreflang="en" href="https://niladict.in/" />
        <xhtml:link rel="alternate" hreflang="ml" href="https://niladict.in/" />
        <xhtml:link rel="alternate" hreflang="en-in" href="https://niladict.in/" />
      </url>
      <!-- Add more URLs as your site grows -->
      <url>
        <loc>https://niladict.in/about</loc>
        <lastmod>#{last_modified}</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.8</priority>
      </url>
      <url>
        <loc>https://niladict.in/privacy</loc>
        <lastmod>#{last_modified}</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.5</priority>
      </url>
    </urlset>
    """

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, sitemap_xml)
  end

  def robots(conn, _params) do
    robots_txt = """
    User-agent: *
    Allow: /

    # Sitemap
    Sitemap: https://niladict.in/sitemap.xml

    # Crawl delay for respectful crawling
    Crawl-delay: 1

    # Disallow certain paths if needed
    # Disallow: /admin/
    # Disallow: /api/
    """

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, robots_txt)
  end
end
