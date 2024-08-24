import glate/compile
import glate/errors
import gleam/dict
import gleeunit/should

pub fn compile_from_string_ok_test() {
  let assert Ok(hello_template) = compile.from_string("Hello, {{ name }}!")
  let data = dict.from_list([#("name", "Gleam")])

  hello_template(data)
  |> should.equal(Ok("Hello, Gleam!"))
}

pub fn compile_from_string_no_whitespace_ok_test() {
  let assert Ok(hello_template) = compile.from_string("Hello, {{name}}!")
  let data = dict.from_list([#("name", "Gleam")])

  hello_template(data)
  |> should.equal(Ok("Hello, Gleam!"))
}

pub fn compile_from_string_not_closed_nok_test() {
  compile.from_string("Hello, {{ name")
  |> should.equal(Error(errors.ParserError("Unexpected end of expression")))
}

pub fn compile_from_string_nok_data_error_test() {
  let assert Ok(hello_template) = compile.from_string("Hello, {{ name }}!")
  let data = dict.from_list([#("foo", "bar")])

  hello_template(data)
  |> should.equal(Error(errors.DataError("Variable `name` not found in data")))
}
