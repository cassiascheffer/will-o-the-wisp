import app/actions/blogs
import app/actions/posts
import app/actions/root_actions
import app/actions/users
import app/context.{type Context}
import app/middleware/web
import gleam/http/request
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  // Check for subdomain in x-wc-blog header set by middleware
  let subdomain = request.get_header(req, "x-wc-blog")

  case subdomain, wisp.path_segments(req) {
    // Blog routes (when subdomain is present)
    Ok(sub), [] -> blogs.show(req, ctx, sub)
    Ok(sub), [slug] -> posts.show(req, ctx, sub, slug)

    // Main site routes (no subdomain)
    Error(_), [] -> root_actions.get_home_page(req)
    Error(_), ["users", id] -> users.one(req, ctx, id)

    // All other paths
    _, _ -> wisp.not_found()
  }
}
