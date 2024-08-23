import glate/lexer
import gleeunit/should

pub fn tokenize_text_ok_test() {
  let source = "<h1>Foo</h1>"
  let tokens = lexer.tokenize(source)

  tokens
  |> should.equal([lexer.TextToken(source)])
}

pub fn tokenize_text_expression_text_ok_test() {
  let source = "<h1>{{ title }}</h1>"
  let tokens = lexer.tokenize(source)

  tokens
  |> should.equal([
    lexer.TextToken("<h1>"),
    lexer.ExpressionStartToken,
    lexer.TextToken(" title "),
    lexer.ExpressionEndToken,
    lexer.TextToken("</h1>"),
  ])
}
