//// A module containing functions to compile a template into a function.

import glate/errors.{type GlateError}
import glate/lexer
import glate/parser
import gleam/dict.{type Dict}
import gleam/result

/// Render an expression into a string.
///
fn render_expression(
  expression: List(parser.Node),
  data: Dict(String, String),
) -> Result(String, GlateError) {
  case expression {
    [parser.VariableNode(name)] -> {
      case data |> dict.get(name) {
        Ok(value) -> Ok(value)
        _ ->
          Error(errors.DataError("Variable `" <> name <> "` not found in data"))
      }
    }
    _ -> panic as "Unexpected expression"
  }
}

/// Render a list of nodes into a string.
///
fn render_nodes(
  nodes: List(parser.Node),
  data: Dict(String, String),
) -> Result(String, GlateError) {
  case nodes {
    [] -> Ok("")
    [node, ..rest] -> {
      case node {
        parser.TextNode(text) -> {
          use rest <- result.try(render_nodes(rest, data))
          Ok(text <> rest)
        }
        parser.ExpressionNode(expression) -> {
          use expression <- result.try(render_expression(expression, data))
          use rest <- result.try(render_nodes(rest, data))
          Ok(expression <> rest)
        }
        _ -> panic as "Unexpected node while rendering"
      }
    }
  }
}

/// Compile a template string into a function.
///
pub fn from_string(
  source: String,
) -> Result(fn(Dict(String, String)) -> Result(String, GlateError), GlateError) {
  let tokens = lexer.tokenize(source)
  use ast <- result.try(parser.parse(tokens))
  Ok(render_nodes(ast, _))
}
