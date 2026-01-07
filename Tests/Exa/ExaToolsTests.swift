import Testing

@testable import Core

@Suite(.testEnvironment, .serialized, .enabledForExa)
struct ExaToolsTests {

  @Test func webSearchBasic() async throws {
    let tool = ExaWebSearchTool()
    let params = ExaWebSearchTool.Parameters(
      query: TestPrompts.searchQuery,
      numResults: nil,
      searchType: nil,
      category: nil,
      showContent: nil,
      includeDomains: nil,
      excludeDomains: nil,
      includeText: nil,
      excludeText: nil,
      startCrawlDate: nil,
      endCrawlDate: nil,
      startPublishedDate: nil,
      endPublishedDate: nil,
      returnText: nil,
      textMaxChars: nil,
      includeHtmlTags: nil,
      returnHighlights: nil,
      highlightsSentences: nil,
      highlightsPerUrl: nil,
      highlightsQuery: nil,
      returnSummary: nil,
      summaryQuery: nil,
      livecrawl: nil,
      subpages: nil,
      subpageTarget: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func deepSearchBasic() async throws {
    let tool = ExaDeepSearchTool()
    let params = ExaDeepSearchTool.Parameters(
      objective: TestPrompts.deepResearchObjective,
      searchQueries: nil,
      numResults: nil,
      category: nil,
      showContent: nil,
      includeDomains: nil,
      excludeDomains: nil,
      includeText: nil,
      excludeText: nil,
      startCrawlDate: nil,
      endCrawlDate: nil,
      startPublishedDate: nil,
      endPublishedDate: nil,
      returnText: nil,
      textMaxChars: nil,
      includeHtmlTags: nil,
      returnHighlights: nil,
      highlightsSentences: nil,
      highlightsPerUrl: nil,
      highlightsQuery: nil,
      returnSummary: nil,
      summaryQuery: nil,
      livecrawl: nil,
      subpages: nil,
      subpageTarget: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func codeContextBasic() async throws {
    let tool = ExaCodeContextTool()
    let params = ExaCodeContextTool.Parameters(
      query: TestPrompts.codeQuery,
      codeTokens: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func crawlUrlBasic() async throws {
    let tool = ExaCrawlUrlTool()
    let params = ExaCrawlUrlTool.Parameters(
      url: TestPrompts.url,
      maxCharacters: nil,
      returnText: nil,
      includeHtmlTags: nil,
      returnHighlights: nil,
      highlightsSentences: nil,
      highlightsPerUrl: nil,
      highlightsQuery: nil,
      returnSummary: nil,
      summaryQuery: nil,
      livecrawl: nil,
      subpages: nil,
      subpageTarget: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func findSimilarBasic() async throws {
    let tool = ExaFindSimilarTool()
    let params = ExaFindSimilarTool.Parameters(
      url: TestPrompts.githubUrl,
      numResults: nil,
      category: nil,
      includeDomains: nil,
      excludeDomains: nil,
      returnText: nil,
      textMaxChars: nil,
      includeHtmlTags: nil,
      returnHighlights: nil,
      highlightsSentences: nil,
      highlightsPerUrl: nil,
      highlightsQuery: nil,
      returnSummary: nil,
      summaryQuery: nil,
      livecrawl: nil,
      subpages: nil,
      subpageTarget: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func companyResearchBasic() async throws {
    let tool = ExaCompanyResearchTool()
    let params = ExaCompanyResearchTool.Parameters(
      companyName: TestPrompts.company,
      numResults: nil,
      startPublishedDate: nil,
      endPublishedDate: nil,
      returnText: nil,
      returnHighlights: nil,
      returnSummary: nil,
      livecrawl: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func linkedinSearchBasic() async throws {
    let tool = ExaLinkedinSearchTool()
    let params = ExaLinkedinSearchTool.Parameters(
      query: TestPrompts.linkedinQuery,
      searchType: nil,
      numResults: nil,
      returnText: nil,
      returnHighlights: nil,
      returnSummary: nil,
      livecrawl: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func quickAnswerBasic() async throws {
    let tool = ExaQuickAnswerTool()
    let params = ExaQuickAnswerTool.Parameters(
      query: TestPrompts.searchQuery,
      showText: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }

  @Test func deepResearchBasic() async throws {
    let tool = ExaDeepResearchTool()
    let params = ExaDeepResearchTool.Parameters(
      instructions: TestPrompts.deepResearchInstructions,
      model: nil,
      showThinking: nil
    )
    let result = try await loggedTest(tool: tool, params: params) {
      try await tool.call(with: params)
    }
    result.assertValidResponse()
  }
}
