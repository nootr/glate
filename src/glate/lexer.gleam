//// A module containing the template lexer

import gleam/string

/// A single token
///
pub type Token {
  ExpressionEndToken
  ExpressionStartToken
  TextToken(String)
}

/// Convert source code into a list of tokens.
///
pub fn tokenize(source: String) -> List(Token) {
  case source {
    "" -> []
    "{{" <> rest -> [ExpressionStartToken, ..tokenize(rest)]
    "}}" <> rest -> [ExpressionEndToken, ..tokenize(rest)]
    _ -> {
      let assert Ok(first) = string.first(source)
      case tokenize(string.drop_left(source, 1)) {
        [TextToken(s), ..tokens] -> [TextToken(first <> s), ..tokens]
        tokens -> [TextToken(first), ..tokens]
      }
    }
  }
}
