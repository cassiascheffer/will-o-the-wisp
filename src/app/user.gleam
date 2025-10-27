import cake/adapter/postgres
import cake/select as s
import cake/where as w
import gleam/dynamic/decode
import gleam/result
import pog

// ---- Types ----

pub type User {
  User(id: String, name: String, email: String)
}

pub type UserError {
  NotFound
  DatabaseError(pog.QueryError)
}

// ---- Decoder ----

pub fn decoder() {
  use id <- decode.field(0, decode.string)
  use name <- decode.field(1, decode.string)
  use email <- decode.field(2, decode.string)
  decode.success(User(id: id, name: name, email: email))
}

// ---- Database Queries ----

pub fn get_by_id(db: pog.Connection, id: String) -> Result(User, UserError) {
  let query =
    s.new()
    |> s.from_table("users")
    |> s.selects([
      s.col("id::text"),
      s.col("name"),
      s.col("email"),
    ])
    |> s.where(w.eq(w.col("id::uuid"), w.string(id)))
    |> s.to_query

  postgres.run_read_query(query, decoder(), db)
  |> result.map_error(DatabaseError)
  |> result.try(fn(users) {
    case users {
      [user, ..] -> Ok(user)
      [] -> Error(NotFound)
    }
  })
}
