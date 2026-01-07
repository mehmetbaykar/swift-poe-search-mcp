import Foundation
import MCPToolkit

struct ExaQuickAnswerTool: MCPTool {
  let name = "exa_quick_answer"
  let description: String? =
    "Get a quick LLM-style answer to a question informed by Exa search results. Provides concise answers with source citations. For more in-depth results, consider using exa_deep_research."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// The question to answer
    let query: String

    /// Show text snippets under each source citation (default: false)
    let showText: Bool?

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "exa-answer"

    let prompt = arguments.query

    var extraBody: [String: Any] = [:]

    if let v = arguments.showText { extraBody["text"] = v }

    let messages = [PoeMessage(role: "user", content: prompt)]

    do {
      let response = try await Environment.current.poeAPIClient().performChatCompletion(
        messages,
        model,
        extraBody.isEmpty ? nil : extraBody,
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
