import Foundation
import MCPToolkit

struct RekaFindSimilarTool: MCPTool {
  let name = "reka_find_similar"
  let description: String? =
    "Find items similar to a target based on a specific attribute using agentic AI analysis. Discovers alternatives, related items, or things that share common characteristics."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// The item, concept, or entity to find similarities for
    let target: String

    /// The specific attribute or characteristic to compare (e.g., "functionality", "style", "purpose", "appearance", "behavior")
    let attribute: String

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "reka-flash"

    let prompt = """
      Find items similar to the given target based on the specified attribute. Provide a detailed analysis and list of similar items with explanations.

      Target: \(arguments.target)
      Attribute to compare: \(arguments.attribute)

      Analyze the target and find similar items based on the "\(arguments.attribute)" attribute. Provide concrete examples and explain why they are similar.
      """

    let messages = [PoeMessage(role: "user", content: prompt)]

    do {
      let response = try await Environment.current.poeAPIClient().performChatCompletion(
        messages,
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
