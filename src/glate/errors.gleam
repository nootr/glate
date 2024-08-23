//// A module containing Glate errors.

/// The error type for the Glate module.
///
pub type GlateError {
  LexerError(String)
  ParserError(String)
  DataError(String)
}
