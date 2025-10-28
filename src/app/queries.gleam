import app/blog.{type Blog}
import app/post.{type Post}
import gleam/result
import pog

// ---- Blog with Posts ----

pub type BlogWithPosts {
  BlogWithPosts(blog: Blog, posts: List(Post))
}

pub type BlogWithPostsError {
  BlogNotFound
  BlogDatabaseError(pog.QueryError)
  PostDatabaseError(pog.QueryError)
}

pub fn fetch_blog_with_posts(
  db: pog.Connection,
  blog_id: String,
) -> Result(BlogWithPosts, BlogWithPostsError) {
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
) -> Result(BlogWithPosts, BlogWithPostsError) {
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

// ---- Post with Blog ----

pub type PostWithBlog {
  PostWithBlog(post: Post, blog: Blog)
}

pub type PostWithBlogError {
  PostNotFound
  BlogNotFoundForPost
  PostWithBlogPostDatabaseError(pog.QueryError)
  PostWithBlogBlogDatabaseError(pog.QueryError)
}

pub fn fetch_post_with_blog(
  db: pog.Connection,
  blog_id: String,
  slug: String,
) -> Result(PostWithBlog, PostWithBlogError) {
  use found_post <- result.try(
    post.get_by_slug(db, blog_id, slug)
    |> result.map_error(fn(err) {
      case err {
        post.NotFound -> PostNotFound
        post.DatabaseError(db_error) -> PostWithBlogPostDatabaseError(db_error)
      }
    }),
  )

  use found_blog <- result.try(
    blog.get_by_id(db, blog_id)
    |> result.map_error(fn(err) {
      case err {
        blog.NotFound -> BlogNotFoundForPost
        blog.DatabaseError(db_error) -> PostWithBlogBlogDatabaseError(db_error)
      }
    }),
  )

  Ok(PostWithBlog(post: found_post, blog: found_blog))
}

pub fn fetch_post_with_blog_by_subdomain(
  db: pog.Connection,
  subdomain: String,
  slug: String,
) -> Result(PostWithBlog, PostWithBlogError) {
  use found_blog <- result.try(
    blog.get_by_subdomain(db, subdomain)
    |> result.map_error(fn(err) {
      case err {
        blog.NotFound -> BlogNotFoundForPost
        blog.DatabaseError(db_error) -> PostWithBlogBlogDatabaseError(db_error)
      }
    }),
  )

  use found_post <- result.try(
    post.get_by_slug(db, found_blog.id, slug)
    |> result.map_error(fn(err) {
      case err {
        post.NotFound -> PostNotFound
        post.DatabaseError(db_error) -> PostWithBlogPostDatabaseError(db_error)
      }
    }),
  )

  Ok(PostWithBlog(post: found_post, blog: found_blog))
}

