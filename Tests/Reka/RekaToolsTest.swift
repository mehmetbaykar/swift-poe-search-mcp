import Testing

@testable import Core

@Suite(.testEnvironment, .serialized, .enabledForReka)
struct RekaToolsTest {
  @Test func findSimilarTool() async throws {
    let tool = RekaFindSimilarTool()
    let params = RekaFindSimilarTool.Parameters(
      target: TestPrompts.findSimilarTarget,
      attribute: TestPrompts.findSimilarAttribute,
      showThinking: false
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func researchTool() async throws {
    let tool = RekaResearchTool()
    let params = RekaResearchTool.Parameters(
      messages: TestPrompts.messages(TestPrompts.factual),
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func verifyClaimTool() async throws {
    let tool = RekaVerifyClaimTool()
    let params = RekaVerifyClaimTool.Parameters(
      claim: TestPrompts.claim,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }
}
