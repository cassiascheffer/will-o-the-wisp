// ABOUTME: Renders user profile content including user details and blog list
// ABOUTME: Provides HTML content for user pages without layout wrapper
import app/models/blog.{type Blog}
import app/models/user.{type User}
import gleam/list
import gleam/string

fn link(href: String, text: String) -> String {
  "<a href=\"" <> href <> "\">" <> text <> "</a>"
}

pub fn render_user_content(user: User, blogs: List(Blog)) -> String {
  let blog_list_html =
    blogs
    |> list.map(fn(b) {
      let primary_badge = case b.primary {
        True -> " <strong>(Primary)</strong>"
        False -> ""
      }
      let url = b.subdomain <> ".willow.camp"
      let label = b.title <> " - " <> b.subdomain <> primary_badge
      "<li>" <> link(url, label) <> "</li>"
    })
    |> string.join("\n")

  "<h1>" <> user.name <> "</h1>
<p>Email: " <> user.email <> "</p>
<h2>Blogs</h2>
<ul>
" <> blog_list_html <> "
</ul>"
}
