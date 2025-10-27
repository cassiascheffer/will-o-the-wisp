// ABOUTME: Action handlers for blog-related requests
// ABOUTME: Handles displaying blog homepages
import app/context.{type Context}
import app/queries/blog_and_posts
import app/views/blog_view
import app/views/layout
import gleam/http
import lustre/element
import pog
import wisp.{type Request, type Response}

pub fn show(req: Request, ctx: Context, subdomain: String) -> Response {
  use <- wisp.require_method(req, http.Get)

  case blog_and_posts.fetch_blog_with_posts_by_subdomain(ctx.db, subdomain) {
    Ok(data) -> {
      let content = blog_view.render_blog_index(data.blog, data.posts)
      let html = element.to_string(content)
      let page = layout.render(data.blog.title, html)
      wisp.html_response(page, 200)
    }
    Error(blog_and_posts.BlogNotFound) -> wisp.not_found()
    Error(blog_and_posts.BlogDatabaseError(db_error)) -> {
      echo #("Blog database error", db_error)
      wisp.internal_server_error()
    }
    Error(blog_and_posts.PostDatabaseError(db_error)) -> {
      echo #("Post database error", db_error)
      wisp.internal_server_error()
    }
  }
}
