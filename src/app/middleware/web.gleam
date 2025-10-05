import exception
import gleam/int
import wisp

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- rescue_and_log_crashes
  use <- log_errors
  use req <- wisp.handle_head(req)
  use req <- wisp.csrf_known_header_protection(req)

  handle_request(req)
}

fn rescue_and_log_crashes(handler: fn() -> wisp.Response) -> wisp.Response {
  case exception.rescue(handler) {
    Ok(response) -> response
    Error(crash) -> {
      echo #("Request handler crashed", crash)
      wisp.internal_server_error()
    }
  }
}

fn log_errors(handler: fn() -> wisp.Response) -> wisp.Response {
  let response = handler()

  case response.status {
    500 | 501 | 502 | 503 | 504 | 505 -> {
      let message = "Server error - Status: " <> int.to_string(response.status)
      wisp.log_error(message)
      response
    }
    _ -> response
  }
}
