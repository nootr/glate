# glate

> 🚧 **This project is under development and not yet ready for use.** 🚧

[![Package Version](https://img.shields.io/hexpm/v/glate)](https://hex.pm/packages/glate)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glate/)

A Gleam library for compiled templates, either during compile-time or runtime.

Glate compiles templates from strings or files into functions that can be called with data to render the template. This is useful for rendering HTML, emails, or any other text-based format.


## Runtime compiled templates

```sh
gleam add glate
```

```gleam
import glate/compile
import gleam/dict
import gleam/io

pub fn main() {
  let assert Ok(hello_template) = compile.from_string("Hello, {{ name }}!")

  let data = dict.from_list([#("name", "Gleam")])
  let html = hello_template(data)

  io.println(html)
}
```


## Compile-time compiled templates

To compile templates at compile-time, add glate as a development dependency and run it as a pre-compilation step.

```sh
gleam add --dev glate
gleam run -m glate --templates templates/*.html --output src/templates.gleam
```

```html
<!-- templates/hello.html -->
Hello, {{ name }}!
```

```gleam
import gleam/dict
import templates

pub fn main() {
    let data = dict.from_list([("name", "Gleam")])
    let html = templates.hello(data)
    io.println(html)
}
```

Further documentation can be found at <https://hexdocs.pm/glate>.


## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
