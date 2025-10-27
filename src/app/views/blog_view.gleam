// ABOUTME: Renders blog homepage with list of posts
// ABOUTME: Displays blog title and published posts
import app/blog.{type Blog}
import app/post.{type Post}
import gleam/list
import gleam/option.{None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn render_blog_index(blog: Blog, posts: List(Post)) -> Element(a) {
  html.div([], [
    html.header([], [
      html.h1([], [html.text(blog.title)]),
      case blog.custom_domain {
        Some(domain) ->
          html.p([attribute.class("blog-domain")], [html.text(domain)])
        None ->
          html.p([attribute.class("blog-domain")], [
            html.text(blog.subdomain <> ".willow.camp"),
          ])
      },
    ]),
    html.main([], [
      case posts {
        [] ->
          html.p([attribute.class("no-posts")], [
            html.text("No posts published yet."),
          ])
        _ -> html.ul([attribute.class("post-list")], list.map(posts, render_post_item))
      },
    ]),
  ])
}

fn render_post_item(post: Post) -> Element(a) {
  html.li([attribute.class("post-item")], [
    html.article([], [
      html.h2([], [
        html.a([attribute.href("/" <> post.slug)], [html.text(post.title)]),
      ]),
      case post.published_at {
        Some(date) ->
          html.time([attribute.class("post-date")], [html.text(date)])
        None -> html.span([], [])
      },
      case post.meta_description {
        Some(desc) ->
          html.p([attribute.class("post-excerpt")], [html.text(desc)])
        None -> html.span([], [])
      },
    ]),
  ])
}
