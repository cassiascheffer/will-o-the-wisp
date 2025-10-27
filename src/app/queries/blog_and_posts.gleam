// ABOUTME: Query composer for fetching a blog with its posts
import app/models/blog.{type Blog, type BlogError}
import app/models/post.{type Post, type PostError}
import gleam/result
import pog

pub type BlogWithPosts {
  BlogWithPosts(blog: Blog, posts: List(Post))
}

pub type FetchError {
  BlogNotFound
  BlogDatabaseError(pog.QueryError)
  PostDatabaseError(pog.QueryError)
}

pub fn fetch_blog_with_posts(
  db: pog.Connection,
  blog_id: String,
) -> Result(BlogWithPosts, FetchError) {
  use found_blog <- result.try(
    blog.get_by_id(db, blog_id)
    |> result.map_error(fn(err) {
      case err {
        blog.NotFound -> BlogNotFound
        blog.DatabaseError(db_error) -> BlogDatabaseError(db_error)
      }
    }),
  )

  use posts <- result.try(
    post.get_published_by_blog_id(db, blog_id)
    |> result.map_error(fn(err) {
      case err {
        post.NotFound -> PostDatabaseError(pog.ConnectionUnavailable)
        post.DatabaseError(db_error) -> PostDatabaseError(db_error)
      }
    }),
  )

  Ok(BlogWithPosts(blog: found_blog, posts: posts))
}

pub fn fetch_blog_with_posts_by_subdomain(
  db: pog.Connection,
  subdomain: String,
) -> Result(BlogWithPosts, FetchError) {
  use found_blog <- result.try(
    blog.get_by_subdomain(db, subdomain)
    |> result.map_error(fn(err) {
      case err {
        blog.NotFound -> BlogNotFound
        blog.DatabaseError(db_error) -> BlogDatabaseError(db_error)
      }
    }),
  )

  use posts <- result.try(
    post.get_published_by_blog_id(db, found_blog.id)
    |> result.map_error(fn(err) {
      case err {
        post.NotFound -> PostDatabaseError(pog.ConnectionUnavailable)
        post.DatabaseError(db_error) -> PostDatabaseError(db_error)
      }
    }),
  )

  Ok(BlogWithPosts(blog: found_blog, posts: posts))
}
