import app/context.{type Context}
import app/models/blog.{type Blog}
import app/models/user.{type User}
import app/views/layout
import app/views/user_view
import gleam/http
import gleam/result
import pog
import wisp.{type Request, type Response}

type FetchError {
  UserNotFound
  DbError(pog.QueryError)
}

fn fetch_user_data(
  db: pog.Connection,
  id: String,
) -> Result(#(User, List(Blog)), FetchError) {
  use found_user <- result.try(
    user.get_by_id(db, id)
    |> result.map_error(fn(err) {
      case err {
        user.NotFound -> UserNotFound
        user.DatabaseError(db_error) -> DbError(db_error)
      }
    }),
  )

  use blogs <- result.try(
    blog.get_by_user_id(db, id)
    |> result.map_error(fn(err) {
      case err {
        blog.DatabaseError(db_error) -> DbError(db_error)
      }
    }),
  )

  Ok(#(found_user, blogs))
}

fn render_user_page(user: User, blogs: List(Blog)) -> String {
  let content = user_view.render_user_content(user, blogs)
  layout.render(user.name, content)
}

pub fn one(req: Request, ctx: Context, id: String) -> Response {
  use <- wisp.require_method(req, http.Get)

  case fetch_user_data(ctx.db, id) {
    Ok(#(user, blogs)) -> wisp.html_response(render_user_page(user, blogs), 200)
    Error(UserNotFound) -> wisp.not_found()
    Error(DbError(db_error)) -> {
      echo #("Database error", db_error)
      wisp.internal_server_error()
    }
  }
}
