import Foundation
import FastMCP

struct RekaResearchTool: MCPTool {
  let name = "reka_research"
  let description: String? =
    "Autonomous research agent that reasons step-by-step in natural language while browsing the web. Performs multi-hop synthesis across sources to answer complex questions that typically require hours of manual research. Accepts an array of messages (each with a role and content) and returns a comprehensive research response."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// Array of conversation messages
    let messages: [PoeMessage]

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "reka-research"

    do {
      let response = try await Environment.current.poeAPIClient().performChatCompletion(
        arguments.messages,
        model,
        nil,
        !(arguments.showThinking ?? false)
      )

      return [ToolContentItem(text: response.content)]
    } catch let error as PoeError {
      throw ToolError(error.localizedDescription)
    } catch {
      throw ToolError("Unexpected error: \(error.localizedDescription)")
    }
  }
}
