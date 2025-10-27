// ABOUTME: Renders individual blog post pages
// ABOUTME: Displays post title, metadata, and body content
import app/blog.{type Blog}
import app/post.{type Post}
import gleam/option.{None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn render_post(post: Post, blog: Blog) -> Element(a) {
  html.div([], [
    html.nav([attribute.class("blog-nav")], [
      html.a([attribute.href("/"  )], [html.text(blog.title)]),
    ]),
    html.article([], [
      html.h1([], [html.text(post.title)]),
      case post.published_at {
        Some(date) ->
          html.p([attribute.class("post-meta")], [
            html.text("Published: " <> date),
          ])
        None ->
          html.p([attribute.class("post-meta")], [html.text("Draft")])
      },
      html.div([attribute.class("post-body")], [
        html.pre([], [html.text(post.body_markdown)]),
      ]),
    ]),
  ])
}
