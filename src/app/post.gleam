import cake/adapter/postgres
import cake/select as s
import cake/where as w
import gleam/dynamic/decode
import gleam/option.{type Option}
import gleam/result
import pog

// ---- Types ----

pub type Post {
  Post(
    id: String,
    title: String,
    body_markdown: String,
    slug: String,
    meta_description: Option(String),
    published: Bool,
    published_at: Option(String),
    featured: Bool,
    author_id: String,
    blog_config_id: String,
    has_mermaid_diagrams: Bool,
    created_at: String,
    updated_at: String,
  )
}

pub type PostError {
  NotFound
  DatabaseError(pog.QueryError)
}

// ---- Decoder ----

pub fn decoder() {
  use id <- decode.field(0, decode.string)
  use title <- decode.field(1, decode.string)
  use body_markdown <- decode.field(2, decode.string)
  use slug <- decode.field(3, decode.string)
  use meta_description <- decode.field(4, decode.optional(decode.string))
  use published <- decode.field(5, decode.bool)
  use published_at <- decode.field(6, decode.optional(decode.string))
  use featured <- decode.field(7, decode.bool)
  use author_id <- decode.field(8, decode.string)
  use blog_config_id <- decode.field(9, decode.string)
  use has_mermaid_diagrams <- decode.field(10, decode.bool)
  use created_at <- decode.field(11, decode.string)
  use updated_at <- decode.field(12, decode.string)
  decode.success(Post(
    id: id,
    title: title,
    body_markdown: body_markdown,
    slug: slug,
    meta_description: meta_description,
    published: published,
    published_at: published_at,
    featured: featured,
    author_id: author_id,
    blog_config_id: blog_config_id,
    has_mermaid_diagrams: has_mermaid_diagrams,
    created_at: created_at,
    updated_at: updated_at,
  ))
}

// ---- Database Queries ----

pub fn get_by_id(db: pog.Connection, id: String) -> Result(Post, PostError) {
  let query =
    s.new()
    |> s.from_table("posts")
    |> s.selects([
      s.col("id::text"),
      s.col("title"),
      s.col("body_markdown"),
      s.col("slug"),
      s.col("meta_description"),
      s.col("published"),
      s.col("published_at::text"),
      s.col("featured"),
      s.col("author_id::text"),
      s.col("blog_config_id::text"),
      s.col("has_mermaid_diagrams"),
      s.col("created_at::text"),
      s.col("updated_at::text"),
    ])
    |> s.where(w.eq(w.col("id::uuid"), w.string(id)))
    |> s.to_query

  postgres.run_read_query(query, decoder(), db)
  |> result.map_error(DatabaseError)
  |> result.try(fn(posts) {
    case posts {
      [post, ..] -> Ok(post)
      [] -> Error(NotFound)
    }
  })
}

pub fn get_by_slug(
  db: pog.Connection,
  blog_id: String,
  slug: String,
) -> Result(Post, PostError) {
  let query =
    s.new()
    |> s.from_table("posts")
    |> s.selects([
      s.col("id::text"),
      s.col("title"),
      s.col("body_markdown"),
      s.col("slug"),
      s.col("meta_description"),
      s.col("published"),
      s.col("published_at::text"),
      s.col("featured"),
      s.col("author_id::text"),
      s.col("blog_config_id::text"),
      s.col("has_mermaid_diagrams"),
      s.col("created_at::text"),
      s.col("updated_at::text"),
    ])
    |> s.where(
      w.and([
        w.eq(w.col("blog_config_id::uuid"), w.string(blog_id)),
        w.eq(w.col("slug"), w.string(slug)),
      ]),
    )
    |> s.to_query

  postgres.run_read_query(query, decoder(), db)
  |> result.map_error(DatabaseError)
  |> result.try(fn(posts) {
    case posts {
      [post, ..] -> Ok(post)
      [] -> Error(NotFound)
    }
  })
}

pub fn get_published_by_blog_id(
  db: pog.Connection,
  blog_id: String,
) -> Result(List(Post), PostError) {
  let query =
    s.new()
    |> s.from_table("posts")
    |> s.selects([
      s.col("id::text"),
      s.col("title"),
      s.col("body_markdown"),
      s.col("slug"),
      s.col("meta_description"),
      s.col("published"),
      s.col("published_at::text"),
      s.col("featured"),
      s.col("author_id::text"),
      s.col("blog_config_id::text"),
      s.col("has_mermaid_diagrams"),
      s.col("created_at::text"),
      s.col("updated_at::text"),
    ])
    |> s.where(
      w.and([
        w.eq(w.col("blog_config_id::uuid"), w.string(blog_id)),
        w.is_true(w.col("published")),
      ]),
    )
    |> s.to_query

  postgres.run_read_query(query, decoder(), db)
  |> result.map_error(DatabaseError)
}
