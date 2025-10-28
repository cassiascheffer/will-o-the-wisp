import argv
import envoy
import gleam/io
import gleam/list
import shellout
import simplifile

pub fn main() {
  case get_command_args() {
    [] -> print_usage()
    ["up"] -> run_migration("up")
    ["down"] -> run_migration("down")
    ["all"] -> run_migration("all")
    ["show"] -> run_cigogne(["show"])
    ["new", "--name", name] -> run_cigogne(["new", "--name", name])
    ["new", ..rest] -> {
      case list.contains(rest, "--name") {
        True -> run_cigogne(["new", ..rest])
        False -> {
          io.println("Error: 'new' command requires --name argument")
          print_usage()
        }
      }
    }
    _ -> {
      io.println("Error: Invalid command")
      print_usage()
    }
  }
}

fn get_command_args() -> List(String) {
  argv.load().arguments
}

fn run_migration(command: String) {
  io.println("\u{001b}[0;34mRunning migration: " <> command <> "\u{001b}[0m")
  run_cigogne([command])
  io.println("")
  dump_schema()
}

fn run_cigogne(args: List(String)) {
  // Build the command: gleam run -m cigogne [args]
  let full_args = ["run", "-m", "cigogne", ..args]
  case shellout.command("gleam", full_args, ".", []) {
    Ok(_) -> Nil
    Error(_) -> Nil
  }
}

fn dump_schema() {
  io.println("\u{001b}[0;33mDumping schema...\u{001b}[0m")

  let database_url = case envoy.get("DATABASE_URL") {
    Ok(url) -> url
    Error(_) -> {
      io.println(
        "\u{001b}[0;31mError: DATABASE_URL environment variable not set\u{001b}[0m",
      )
      ""
    }
  }

  case database_url {
    "" -> Nil
    url -> {
      let args = [
        "--schema-only", "--no-owner", "--no-acl",
        "--exclude-schema=information_schema", "--exclude-schema=pg_catalog",
        "--schema=public", url,
      ]

      case shellout.command("pg_dump", args, ".", []) {
        Ok(output) -> {
          case simplifile.write("priv/schema.sql", output) {
            Ok(_) ->
              io.println(
                "\u{001b}[0;32m✓ Schema dumped to priv/schema.sql\u{001b}[0m",
              )
            Error(_) ->
              io.println(
                "\u{001b}[0;31m✗ Failed to write schema file\u{001b}[0m",
              )
          }
        }
        Error(_) ->
          io.println(
            "\u{001b}[0;31m✗ Failed to dump schema (pg_dump failed)\u{001b}[0m",
          )
      }
    }
  }
}

fn print_usage() {
  io.println("Usage: gleam run -m migrate COMMAND")
  io.println("")
  io.println("Commands:")
  io.println("  up              Apply the next migration")
  io.println("  down            Roll back the last applied migration")
  io.println("  all             Apply all migrations not yet applied")
  io.println("  show            Show the applied migrations")
  io.println("  new --name NAME Create a new migration with name NAME")
}

