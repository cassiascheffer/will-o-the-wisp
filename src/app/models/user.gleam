import gleam/dynamic/decode
import gleam/result
import pog

pub type User {
  User(id: String, name: String, email: String)
}

pub type UserError {
  NotFound
  DatabaseError(pog.QueryError)
}

pub fn decoder() {
  use id <- decode.field(0, decode.string)
  use name <- decode.field(1, decode.string)
  use email <- decode.field(2, decode.string)
  decode.success(User(id: id, name: name, email: email))
}

pub fn get_by_id(db: pog.Connection, id: String) -> Result(User, UserError) {
  let sql = "SELECT id::text, name, email FROM users WHERE id = $1::uuid"

  pog.query(sql)
  |> pog.parameter(pog.text(id))
  |> pog.returning(decoder())
  |> pog.execute(db)
  |> result.map_error(DatabaseError)
  |> result.try(fn(response) {
    case response.rows {
      [user, ..] -> Ok(user)
      [] -> Error(NotFound)
    }
  })
}
