import MCPToolkit
import Testing

extension Array where Element == ToolContentItem {
  func assertValidResponse() {
    #expect(!isEmpty, "Response should not be empty - API returned no content items")
    #expect(count >= 1, "Response should have at least one content item")
  }
}
