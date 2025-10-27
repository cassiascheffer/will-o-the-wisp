// ABOUTME: Action handlers for post-related requests
// ABOUTME: Handles displaying individual blog posts
import app/context.{type Context}
import app/queries/post_and_blog
import app/views/layout
import app/views/post_view
import gleam/http
import lustre/element
import wisp.{type Request, type Response}

pub fn show(
  req: Request,
  ctx: Context,
  blog_id: String,
  slug: String,
) -> Response {
  use <- wisp.require_method(req, http.Get)

  case post_and_blog.fetch_post_with_blog(ctx.db, blog_id, slug) {
    Ok(data) -> {
      case data.post.published {
        True -> {
          let content = post_view.render_post(data.post, data.blog)
          let html = element.to_string(content)
          let page = layout.render(data.post.title, html)
          wisp.html_response(page, 200)
        }
        False -> wisp.not_found()
      }
    }
    Error(post_and_blog.PostNotFound) -> wisp.not_found()
    Error(post_and_blog.BlogNotFound) -> wisp.not_found()
    Error(post_and_blog.PostDatabaseError(db_error)) -> {
      echo #("Post database error", db_error)
      wisp.internal_server_error()
    }
    Error(post_and_blog.BlogDatabaseError(db_error)) -> {
      echo #("Blog database error", db_error)
      wisp.internal_server_error()
    }
  }
}
