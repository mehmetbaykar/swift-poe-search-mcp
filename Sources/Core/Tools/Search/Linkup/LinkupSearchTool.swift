import Foundation
import MCPToolkit

struct LinkupSearchTool: MCPTool {
  let name = "linkup_search"
  let description: String? =
    "Search the web using Linkup AI. Ranked #1 globally for factual accuracy on OpenAI's SimpleQA benchmark. Use 'standard' depth for quick answers (weather, stocks, facts) or 'deep' for comprehensive research across multiple sources."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    let messages: [PoeMessage]
    let depth: SearchDepth?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let depth = arguments.depth ?? .standard
    let model = depth == .deep ? "linkup-deep-search" : "linkup-standard"

    do {
      let response = try await Environment.current.poeAPIClient().performChatCompletion(
        arguments.messages,
        model,
        nil,
        false
      )
      return [ToolContentItem(text: response.content)]
    } catch let error as PoeError {
      throw ToolError(error.localizedDescription)
    } catch {
      throw ToolError("Unexpected error: \(error.localizedDescription)")
    }
  }
}
