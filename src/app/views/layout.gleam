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
</head>
<body>
"
  <> content
  <> "
</body>
</html>"
}
