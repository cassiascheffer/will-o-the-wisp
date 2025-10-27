import gleam/http/request
import gleam/result
import gleam/string
import wisp

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = case get_subdomain(req) {
    Ok(subdomain) -> request.set_header(req, "x-wc-blog", subdomain)
    Error(_) -> req
  }

  handle_request(req)
}

fn get_subdomain(req: wisp.Request) -> Result(String, Nil) {
  use host <- result.try(request.get_header(req, "host"))

  // Remove port if present
  let host = case string.split(host, ":") {
    [h, ..] -> h
    [] -> host
  }

  // Check if it matches *.willow.camp or *.localhost pattern
  case string.split(host, ".") {
    [subdomain, "willow", "camp"] if subdomain != "www" -> Ok(subdomain)
    [subdomain, "localhost"] if subdomain != "www" -> Ok(subdomain)
    _ -> Error(Nil)
  }
}
