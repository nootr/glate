//// A module containing the template parser

import glate/errors.{type GlateError}
import glate/lexer
import gleam/result
import gleam/string

/// A single AST node
///
pub type Node {
  TextNode(String)
  ExpressionNode(List(Node))
  VariableNode(String)
}

fn parse_expression(
  tokens: List(lexer.Token),
) -> Result(#(List(Node), List(lexer.Token)), GlateError) {
  case tokens {
    [lexer.ExpressionEndToken, ..rest] -> Ok(#([], rest))
    [lexer.TextToken(text), ..rest] -> {
      use #(nodes, tokens) <- result.try(parse_expression(rest))
      let stripped_text = string.trim(text)
      case string.contains(stripped_text, " ") {
        True -> {
          Error(errors.ParserError("Variable names cannot contain spaces"))
        }
        False -> Ok(#([VariableNode(stripped_text), ..nodes], tokens))
      }
    }
    [] -> Error(errors.ParserError("Unexpected end of expression"))
    _ -> Error(errors.ParserError("Unexpected token in expression"))
  }
}

/// Convert a list of tokens into a list of nodes
pub fn parse(tokens: List(lexer.Token)) -> Result(List(Node), GlateError) {
  case tokens {
    [] -> Ok([])
    [lexer.TextToken(text), ..rest] -> {
      use nodes <- result.try(parse(rest))
      Ok([TextNode(text), ..nodes])
    }
    [lexer.ExpressionStartToken, ..rest] -> {
      use #(expression, rest) <- result.try(parse_expression(rest))
      use nodes <- result.try(parse(rest))
      Ok([ExpressionNode(expression), ..nodes])
    }
    _ -> Error(errors.ParserError("Unexpected token"))
  }
}
