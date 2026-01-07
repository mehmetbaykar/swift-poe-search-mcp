import Testing

@testable import Core

@Suite(.testEnvironment, .serialized, .enabledForLinkup)
struct LinkupToolsTest {
  @Test func searchStandard() async throws {
    let tool = LinkupSearchTool()
    let params = LinkupSearchTool.Parameters(
      messages: TestPrompts.messages(TestPrompts.factual),
      depth: .standard
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func searchDeep() async throws {
    let tool = LinkupSearchTool()
    let params = LinkupSearchTool.Parameters(
      messages: TestPrompts.messages(TestPrompts.research),
      depth: .deep
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func searchDefaultDepth() async throws {
    let tool = LinkupSearchTool()
    let params = LinkupSearchTool.Parameters(
      messages: TestPrompts.messages(TestPrompts.math),
      depth: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }
}
