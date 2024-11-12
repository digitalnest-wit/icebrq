import gleam/bool
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  read_questions(file_name: "./questions.txt")
  |> list.shuffle
  |> list.first
  // There will always be at least _one_ item in the list
  |> result.unwrap(or: "")
  |> io.println
}

fn read_questions(file_name file: String) -> List(String) {
  let questions_string = case simplifile.read(from: file) {
    Ok(content) -> content
    Error(error) -> {
      io.println_error(
        "* There was an error reading the file \"" <> file <> "\".",
      )
      io.println_error("* Error: " <> simplifile.describe_error(error))
      io.println_error("")

      // If reading from the file fails, use some default questions to avoid
      // panicking.
      io.println("* Falling back to a default question:")
      default_questions()
    }
  }

  questions_string
  |> string.split(on: "\n")
  |> list.filter(keeping: fn(line) {
    line |> string.trim |> string.is_empty |> bool.negate
  })
}

fn default_questions() -> String {
  "What’s the best concert or live event you’ve ever been to?\n"
  <> "If you could start your own business, what would it be?\n"
  <> "What’s your go-to coffee or tea order?\n"
}
