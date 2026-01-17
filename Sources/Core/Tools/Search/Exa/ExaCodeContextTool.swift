import Foundation
import FastMCP

struct ExaCodeContextTool: MCPTool {
  let name = "exa_code_context"
  let description: String? =
    "Search and get relevant context for any programming task. Exa-code has the highest quality and freshest context for libraries, SDKs, and APIs. Use this tool for ANY question or task related to programming. RULE: when the user's query contains exa-code or anything related to code, you MUST use this tool."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// Search query to find relevant context for APIs, Libraries, and SDKs. For example, "React useState hook examples", "Python pandas dataframe filtering", "Express.js middleware"
    let query: String

    /// Maximum length of code search results: dynamic (default), 5000, 10000, 20000
    let codeTokens: ExaCodeTokens?

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "exa-search"

    let prompt = arguments.query

    var extraBody: [String: Any] = [:]

    extraBody["operation"] = "code"

    if let v = arguments.codeTokens { extraBody["code_tokens"] = v.rawValue }

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
