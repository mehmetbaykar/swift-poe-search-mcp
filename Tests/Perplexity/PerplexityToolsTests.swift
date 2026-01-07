import Testing

@testable import Core

@Suite(.testEnvironment, .serialized, .enabledForPerplexity)
struct PerplexityToolsTests {

  @Test func askTool() async throws {
    let tool = PerplexityAskTool()
    let params = PerplexityAskTool.Parameters(
      messages: TestPrompts.messages(TestPrompts.technical),
      searchContextSize: nil,
      searchMode: nil,
      searchDomainFilter: nil,
      searchLanguageFilter: nil,
      searchRecencyFilter: nil,
      searchAfterDate: nil,
      searchBeforeDate: nil,
      country: nil,
      region: nil,
      city: nil,
      latitude: nil,
      longitude: nil,
      returnImages: nil,
      returnVideos: nil,
      imageDomainFilter: nil,
      imageFormatFilter: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func reasonTool() async throws {
    let tool = PerplexityReasonTool()
    let params = PerplexityReasonTool.Parameters(
      messages: TestPrompts.messages(TestPrompts.factual),
      showThinking: nil,
      searchContextSize: nil,
      searchMode: nil,
      searchDomainFilter: nil,
      searchLanguageFilter: nil,
      searchRecencyFilter: nil,
      searchAfterDate: nil,
      searchBeforeDate: nil,
      country: nil,
      region: nil,
      city: nil,
      latitude: nil,
      longitude: nil,
      returnImages: nil,
      returnVideos: nil,
      imageDomainFilter: nil,
      imageFormatFilter: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func researchTool() async throws {
    let tool = PerplexityResearchTool()
    let params = PerplexityResearchTool.Parameters(
      messages: TestPrompts.messages(TestPrompts.research),
      showThinking: nil,
      reasoningEffort: nil,
      searchMode: nil,
      searchDomainFilter: nil,
      searchAfterDateFilter: nil,
      searchBeforeDateFilter: nil,
      lastUpdatedAfterFilter: nil,
      lastUpdatedBeforeFilter: nil,
      country: nil,
      latitude: nil,
      longitude: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }
}
