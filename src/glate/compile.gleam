//// A module containing functions to compile a template into a function.

import glate/errors.{type GlateError}
import glate/lexer
import glate/parser
import gleam/dict.{type Dict}

/// Compile a template string into a function.
///
pub fn from_string(
  source: String,
) -> Result(fn(Dict(String, String)) -> Result(String, GlateError), GlateError) {
  let tokens = lexer.tokenize(source)
  let _ast = parser.parse(tokens)
  let function = fn(_data) -> Result(String, GlateError) { Ok(source) }
  Ok(function)
}
