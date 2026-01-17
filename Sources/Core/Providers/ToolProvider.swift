import FastMCP
import Foundation

public struct ToolProvider: Sendable {
  public var get: @Sendable () -> [any MCPTool]
}

extension ToolProvider {
  static var liveValue: ToolProvider {
    .init(get: {
      let config = Environment.current.config()
      var tools: [any MCPTool] = []

      if config.isProviderEnabled(.perplexity) {
        tools += [
          PerplexityAskTool(),
          PerplexityReasonTool(),
          PerplexityResearchTool(),
        ]
      }

      if config.isProviderEnabled(.reka) {
        tools += [
          RekaResearchTool(),
          RekaVerifyClaimTool(),
          RekaFindSimilarTool(),
        ]
      }

      if config.isProviderEnabled(.linkup) {
        tools += [LinkupSearchTool()]
      }

      if config.isProviderEnabled(.exa) {
        tools += [
          ExaWebSearchTool(),
          ExaDeepSearchTool(),
          ExaCodeContextTool(),
          ExaCrawlUrlTool(),
          ExaFindSimilarTool(),
          ExaCompanyResearchTool(),
          ExaLinkedinSearchTool(),
          ExaQuickAnswerTool(),
          ExaDeepResearchTool(),
        ]
      }

      if config.isProviderEnabled(.poe) {
        tools += [PoeFastWebSearchTool()]
      }

      return tools
    })
  }
}
