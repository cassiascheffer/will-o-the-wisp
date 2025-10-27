// ABOUTME: Query composer for fetching a post with its parent blog
import app/models/blog.{type Blog, type BlogError}
import app/models/post.{type Post, type PostError}
import gleam/result
import pog

pub type PostWithBlog {
  PostWithBlog(post: Post, blog: Blog)
}

pub type FetchError {
  PostNotFound
  BlogNotFound
  PostDatabaseError(pog.QueryError)
  BlogDatabaseError(pog.QueryError)
}

pub fn fetch_post_with_blog(
  db: pog.Connection,
  blog_id: String,
  slug: String,
) -> Result(PostWithBlog, FetchError) {
  use found_post <- result.try(
    post.get_by_slug(db, blog_id, slug)
    |> result.map_error(fn(err) {
      case err {
        post.NotFound -> PostNotFound
        post.DatabaseError(db_error) -> PostDatabaseError(db_error)
      }
    }),
  )

  use found_blog <- result.try(
    blog.get_by_id(db, blog_id)
    |> result.map_error(fn(err) {
      case err {
        blog.NotFound -> BlogNotFound
        blog.DatabaseError(db_error) -> BlogDatabaseError(db_error)
      }
    }),
  )

  Ok(PostWithBlog(post: found_post, blog: found_blog))
}

pub fn fetch_post_with_blog_by_subdomain(
  db: pog.Connection,
  subdomain: String,
  slug: String,
) -> Result(PostWithBlog, FetchError) {
  use found_blog <- result.try(
    blog.get_by_subdomain(db, subdomain)
    |> result.map_error(fn(err) {
      case err {
        blog.NotFound -> BlogNotFound
        blog.DatabaseError(db_error) -> BlogDatabaseError(db_error)
      }
    }),
  )

  use found_post <- result.try(
    post.get_by_slug(db, found_blog.id, slug)
    |> result.map_error(fn(err) {
      case err {
        post.NotFound -> PostNotFound
        post.DatabaseError(db_error) -> PostDatabaseError(db_error)
      }
    }),
  )

  Ok(PostWithBlog(post: found_post, blog: found_blog))
}
