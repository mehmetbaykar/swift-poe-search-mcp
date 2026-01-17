import FastMCP

@Schemable
enum SearchDepth: String, Codable, Sendable, CaseIterable {
  case standard
  case deep
}
