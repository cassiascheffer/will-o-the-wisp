import gleam/erlang/process
import gleam/otp/actor
import gleam/otp/static_supervisor as supervisor
import gleam/result
import pog

pub fn start_pool(
  host: String,
  database: String,
  pool_size: Int,
) -> Result(process.Name(pog.Message), actor.StartError) {
  let pool_name = process.new_name("db_pool")

  let pool_child =
    pog.default_config(pool_name)
    |> pog.host(host)
    |> pog.database(database)
    |> pog.user("postgres")
    |> pog.pool_size(pool_size)
    |> pog.supervised

  supervisor.new(supervisor.RestForOne)
  |> supervisor.add(pool_child)
  |> supervisor.start
  |> result.map(fn(_) { pool_name })
}

pub fn get_connection(pool_name: process.Name(pog.Message)) -> pog.Connection {
  pog.named_connection(pool_name)
}
