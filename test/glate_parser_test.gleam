import glate/lexer
import glate/parser
import gleeunit/should

pub fn parse_text_ok_test() {
  let source = "<h1>Foo</h1>"
  let tokens = lexer.tokenize(source)
  let nodes = parser.parse(tokens)

  nodes
  |> should.equal(Ok([parser.TextNode("<h1>Foo</h1>")]))
}

pub fn parse_text_expression_text_ok_test() {
  let source = "<h1>{{ title }}</h1>"
  let tokens = lexer.tokenize(source)
  let nodes = parser.parse(tokens)

  nodes
  |> should.equal(
    Ok([
      parser.TextNode("<h1>"),
      parser.ExpressionNode([parser.VariableNode("title")]),
      parser.TextNode("</h1>"),
    ]),
  )
}
