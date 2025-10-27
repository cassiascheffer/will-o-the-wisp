import app/actions/root_actions
import app/actions/users
import app/context.{type Context}
import app/middleware/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req)

  // Wisp doesn't have a special router abstraction, instead we recommend using
  // regular old pattern matching. This is faster than a router, is type safe,
  // and means you don't have to learn or be limited by a special DSL.
  //
  case wisp.path_segments(req) {
    // This matches `/`.
    [] -> root_actions.get_home_page(req)

    // This matches /users/:id
    ["users", id] -> users.one(req, ctx, id)

    // This matches all other paths.
    _ -> wisp.not_found()
  }
}
