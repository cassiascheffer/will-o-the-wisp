// ABOUTME: Provides the main HTML layout structure for all pages
// ABOUTME: Handles rendering the full HTML document with head and body elements

pub fn render(title: String, content: String) -> String {
  "<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"UTF-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <title>"
  <> title
  <> "</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
    }

    h1 {
      font-size: 2.5rem;
      margin-bottom: 1rem;
      color: #111;
    }

    h2 {
      font-size: 1.8rem;
      margin-top: 2rem;
      margin-bottom: 0.5rem;
      color: #222;
    }

    p {
      margin-bottom: 1rem;
    }

    a {
      color: #0066cc;
      text-decoration: none;
    }

    a:hover {
      text-decoration: underline;
    }

    nav.blog-nav {
      margin-bottom: 2rem;
      padding-bottom: 1rem;
      border-bottom: 1px solid #ddd;
    }

    .post-list {
      list-style: none;
    }

    .post-item {
      margin-bottom: 2rem;
      padding-bottom: 2rem;
      border-bottom: 1px solid #eee;
    }

    .post-item:last-child {
      border-bottom: none;
    }

    .post-date, .post-meta {
      color: #666;
      font-size: 0.9rem;
      margin-bottom: 0.5rem;
    }

    .post-excerpt {
      color: #555;
    }

    .post-body pre {
      background: #f5f5f5;
      padding: 1rem;
      overflow-x: auto;
      border-radius: 4px;
      line-height: 1.4;
    }

    .no-posts {
      color: #999;
      font-style: italic;
    }

    ul {
      list-style-position: inside;
      margin-bottom: 1rem;
    }

    @media (max-width: 600px) {
      body {
        padding: 1rem;
      }

      h1 {
        font-size: 2rem;
      }

      h2 {
        font-size: 1.5rem;
      }
    }
  </style>
</head>
<body>
"
  <> content
  <> "
</body>
</html>"
}
