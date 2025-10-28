import app/blog.{type Blog}
import app/post.{type Post}
import cake_knife/offset
import gleam/int
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

pub fn render_blog_index_with_pagination(
  blog: Blog,
  posts_page: offset.Page(Post),
) -> Element(a) {
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
      case posts_page.data {
        [] ->
          html.p([attribute.class("no-posts")], [
            html.text("No posts published yet."),
          ])
        _ ->
          html.ul(
            [attribute.class("post-list")],
            list.map(posts_page.data, render_post_item),
          )
      },
      render_pagination(posts_page),
    ]),
  ])
}

fn render_pagination(page: offset.Page(a)) -> Element(b) {
  case page.total_pages > 1 {
    False -> html.div([], [])
    True ->
      html.nav([attribute.class("pagination")], [
        case page.has_previous {
          True ->
            html.a(
              [
                attribute.href("?page=" <> int.to_string(page.page - 1)),
                attribute.class("pagination-link"),
              ],
              [html.text("← Previous")],
            )
          False ->
            html.span([attribute.class("pagination-link disabled")], [
              html.text("← Previous"),
            ])
        },
        html.span([attribute.class("pagination-info")], [
          html.text(
            "Page " <> int.to_string(page.page) <> " of " <> int.to_string(
              page.total_pages,
            ),
          ),
        ]),
        case page.has_next {
          True ->
            html.a(
              [
                attribute.href("?page=" <> int.to_string(page.page + 1)),
                attribute.class("pagination-link"),
              ],
              [html.text("Next →")],
            )
          False ->
            html.span([attribute.class("pagination-link disabled")], [
              html.text("Next →"),
            ])
        },
      ])
  }
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
