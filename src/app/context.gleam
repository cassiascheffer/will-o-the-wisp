import pog

pub type Context {
  Context(db: pog.Connection)
}

pub fn new(db: pog.Connection) -> Context {
  Context(db: db)
}
