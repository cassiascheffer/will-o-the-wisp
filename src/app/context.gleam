import app/blog.{type Blog}
import gleam/option.{type Option}
import pog

pub type Context {
  Context(db: pog.Connection, blog: Option(Blog))
}

pub fn new(db: pog.Connection) -> Context {
  Context(db: db, blog: option.None)
}

pub fn with_blog(ctx: Context, blog: Blog) -> Context {
  Context(..ctx, blog: option.Some(blog))
}
