// ABOUTME: Defines the Blog model and database queries for blogs
// ABOUTME: Handles querying blogs by user_id, subdomain, and id from the database
import cake/adapter/postgres
import cake/select as s
import cake/where as w
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
  NotFound
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
  let query =
    s.new()
    |> s.from_table("blog_configs")
    |> s.selects([
      s.col("id::text"),
      s.col("user_id::text"),
      s.col("subdomain"),
      s.col("title"),
      s.col("custom_domain"),
      s.col("theme"),
      s.col("post_footer_markdown"),
      s.col("\"primary\""),
    ])
    |> s.where(w.eq(w.col("user_id::uuid"), w.string(user_id)))
    |> s.to_query

  postgres.run_read_query(query, decoder(), db)
  |> result.map_error(DatabaseError)
}

pub fn get_by_subdomain(
  db: pog.Connection,
  subdomain: String,
) -> Result(Blog, BlogError) {
  let query =
    s.new()
    |> s.from_table("blog_configs")
    |> s.selects([
      s.col("id::text"),
      s.col("user_id::text"),
      s.col("subdomain"),
      s.col("title"),
      s.col("custom_domain"),
      s.col("theme"),
      s.col("post_footer_markdown"),
      s.col("\"primary\""),
    ])
    |> s.where(w.eq(w.col("subdomain"), w.string(subdomain)))
    |> s.to_query

  postgres.run_read_query(query, decoder(), db)
  |> result.map_error(DatabaseError)
  |> result.try(fn(blogs) {
    case blogs {
      [blog, ..] -> Ok(blog)
      [] -> Error(NotFound)
    }
  })
}

pub fn get_by_id(db: pog.Connection, id: String) -> Result(Blog, BlogError) {
  let query =
    s.new()
    |> s.from_table("blog_configs")
    |> s.selects([
      s.col("id::text"),
      s.col("user_id::text"),
      s.col("subdomain"),
      s.col("title"),
      s.col("custom_domain"),
      s.col("theme"),
      s.col("post_footer_markdown"),
      s.col("\"primary\""),
    ])
    |> s.where(w.eq(w.col("id::uuid"), w.string(id)))
    |> s.to_query

  postgres.run_read_query(query, decoder(), db)
  |> result.map_error(DatabaseError)
  |> result.try(fn(blogs) {
    case blogs {
      [blog, ..] -> Ok(blog)
      [] -> Error(NotFound)
    }
  })
}
