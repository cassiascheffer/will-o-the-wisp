import app/context.{type Context}
import app/middleware/web
import app/queries
import app/root
import app/views/blog_view
import app/views/layout
import app/views/post_view
import gleam/http
import gleam/http/request
import gleam/int
import gleam/list
import gleam/result
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  // Check for subdomain in x-wc-blog header set by middleware
  let subdomain = request.get_header(req, "x-wc-blog")

  case subdomain, wisp.path_segments(req) {
    // Blog routes (when subdomain is present)
    Ok(sub), [] -> handle_blog_index(req, ctx, sub)
    Ok(sub), [slug] -> handle_post_show(req, ctx, sub, slug)

    // Main site routes (no subdomain)
    Error(_), [] -> root.get_home_page(req)

    // All other paths
    _, _ -> wisp.not_found()
  }
}

fn handle_blog_index(req: Request, ctx: Context, subdomain: String) -> Response {
  use <- wisp.require_method(req, http.Get)

  let page =
    request.get_query(req)
    |> result.try(fn(query_params) {
      list.key_find(query_params, "page")
    })
    |> result.try(int.parse)
    |> result.unwrap(1)

  let page = case page < 1 {
    True -> 1
    False -> page
  }

  let per_page = 10

  case
    queries.fetch_blog_with_posts_page_by_subdomain(
      ctx.db,
      subdomain,
      page,
      per_page,
    )
  {
    Ok(data) -> {
      let content =
        blog_view.render_blog_index_with_pagination(
          data.blog,
          data.posts_page,
        )
      let page_title = data.blog.title
      let page_html = layout.render(page_title, content)
      let html = element.to_string(page_html)
      wisp.html_response(html, 200)
    }
    Error(queries.BlogNotFound) -> wisp.not_found()
    Error(queries.BlogDatabaseError(db_error)) -> {
      echo #("Blog database error", db_error)
      wisp.internal_server_error()
    }
    Error(queries.PostDatabaseError(db_error)) -> {
      echo #("Post database error", db_error)
      wisp.internal_server_error()
    }
  }
}

fn handle_post_show(
  req: Request,
  ctx: Context,
  subdomain: String,
  slug: String,
) -> Response {
  use <- wisp.require_method(req, http.Get)

  case queries.fetch_post_with_blog_by_subdomain(ctx.db, subdomain, slug) {
    Ok(data) -> {
      case data.post.published {
        True -> {
          let content = post_view.render_post(data.post, data.blog)
          let page = layout.render(data.post.title, content)
          let html = element.to_string(page)
          wisp.html_response(html, 200)
        }
        False -> wisp.not_found()
      }
    }
    Error(queries.PostNotFound) -> wisp.not_found()
    Error(queries.BlogNotFoundForPost) -> wisp.not_found()
    Error(queries.PostWithBlogPostDatabaseError(db_error)) -> {
      echo #("Post database error", db_error)
      wisp.internal_server_error()
    }
    Error(queries.PostWithBlogBlogDatabaseError(db_error)) -> {
      echo #("Blog database error", db_error)
      wisp.internal_server_error()
    }
  }
}

