import Foundation
import MCPToolkit

struct RekaVerifyClaimTool: MCPTool {
  let name = "reka_verify_claim"
  let description: String? =
    "Fact-check and verify claims using agentic AI analysis. Returns a structured assessment with verdict (true/false/uncertain), confidence score (0-1), and detailed reasoning."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// The claim or statement to fact-check and verify
    let claim: String

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "reka-flash"

    let prompt =
      "Analyze the given claim and provide a verification assessment. Return your response as a JSON object with 'verdict' (true/false/uncertain), 'confidence' (0-1), and 'reasoning' fields. Please verify this claim: \(arguments.claim)"

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
