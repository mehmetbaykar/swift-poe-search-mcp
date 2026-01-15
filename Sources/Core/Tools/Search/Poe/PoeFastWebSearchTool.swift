import Foundation
import MCPToolkit

struct PoeFastWebSearchTool: MCPTool {
  let name = "poe_fast_web_search"
  let description: String? =
    "Fast, cheap web search for quick facts and updated information. Powered by Gemini 2.0 Flash. Prefer for simple queries - a cost-effective alternative to perplexity_ask."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    let messages: [PoeMessage]
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    do {
      let response = try await Environment.current.poeAPIClient().performChatCompletion(
        arguments.messages,
        "web-search",
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
