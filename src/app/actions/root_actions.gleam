import gleam/http
import wisp.{type Request, type Response}

pub fn get_home_page(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)

  // Later we'll use templates, but for now a string will do.
  let body = "<h1>Hello, Willow!</h1>"

  // Return a 200 OK response with the body and a HTML content type.
  wisp.html_response(body, 200)
}
