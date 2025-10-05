import app/context
import app/database
import app/router
import envoy
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/result
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  let web_port =
    envoy.get("WEB_PORT")
    |> result.unwrap("8080")
    |> int.parse
    |> result.unwrap(8080)
  let db_host = envoy.get("DB_HOST") |> result.unwrap("localhost")
  let db_name = envoy.get("DB_NAME") |> result.unwrap("wc_gleam")
  let db_pool =
    envoy.get("DB_POOL")
    |> result.unwrap("15")
    |> int.parse
    |> result.unwrap(15)

  let assert Ok(pool_name) = database.start_pool(db_host, db_name, db_pool)
  io.println("Database pool started successfully")

  let db = database.get_connection(pool_name)
  let ctx = context.new(db)
  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request(_, ctx), secret_key_base)
    |> mist.new
    |> mist.port(web_port)
    |> mist.start

  io.println("Server started successfully - listening on http://127.0.0.1:8000")

  process.sleep_forever()
}
