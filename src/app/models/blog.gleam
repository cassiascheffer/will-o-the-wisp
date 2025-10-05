// ABOUTME: Defines the Blog model and database queries for blogs
// ABOUTME: Handles querying blogs by user_id from the database
import gleam/dynamic/decode
import gleam/option
import gleam/result
import pog

pub type Blog {
  Blog(
    id: String,
    user_id: String,
    subdomain: String,
    title: String,
    custom_domain: option.Option(String),
    theme: String,
    post_footer_markdown: option.Option(String),
    primary: Bool,
  )
}

pub type BlogError {
  DatabaseError(pog.QueryError)
}

pub fn decoder() {
  use id <- decode.field(0, decode.string)
  use user_id <- decode.field(1, decode.string)
  use subdomain <- decode.field(2, decode.string)
  use title <- decode.field(3, decode.string)
  use custom_domain <- decode.field(4, decode.optional(decode.string))
  use theme <- decode.field(5, decode.string)
  use post_footer_markdown <- decode.field(6, decode.optional(decode.string))
  use primary <- decode.field(7, decode.bool)
  decode.success(Blog(
    id: id,
    user_id: user_id,
    subdomain: subdomain,
    title: title,
    custom_domain: custom_domain,
    theme: theme,
    post_footer_markdown: post_footer_markdown,
    primary: primary,
  ))
}

pub fn get_by_user_id(
  db: pog.Connection,
  user_id: String,
) -> Result(List(Blog), BlogError) {
  let sql =
    "SELECT
      id::text,
      user_id::text,
      subdomain,
      title,
      custom_domain,
      theme,
      post_footer_markdown,
      \"primary\"
    FROM blogs WHERE user_id = $1::uuid"

  pog.query(sql)
  |> pog.parameter(pog.text(user_id))
  |> pog.returning(decoder())
  |> pog.execute(db)
  |> result.map(fn(response) { response.rows })
  |> result.map_error(DatabaseError)
}
