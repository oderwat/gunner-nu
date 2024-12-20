import gleam/erlang/process
import gleam/io

pub fn main() {
  let fun = fn() {
    process.sleep(100)
    io.println("Hello from another process running concurrently!")
  }
  process.start(fun, True)
  io.println("Hello from the main process!")
  // sleeps 100 ms
  process.sleep(200)
}
