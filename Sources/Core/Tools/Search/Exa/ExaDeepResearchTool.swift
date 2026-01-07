import Foundation
import MCPToolkit

struct ExaDeepResearchTool: MCPTool {
  let name = "exa_deep_research"
  let description: String? =
    "Start a comprehensive AI-powered deep research task for complex queries. This tool initiates an intelligent agent that performs extensive web searches, crawls relevant pages, analyzes information, and synthesizes findings into a detailed research report. The agent thinks critically about the research topic and provides thorough, well-sourced answers. Use this for complex research questions that require in-depth analysis rather than simple searches. Note: Responses may take 15s-2min depending on model complexity."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// Complex research question or detailed instructions for the AI researcher. Be specific about what you want to research and any particular aspects you want covered.
    let instructions: String

    /// Research model: exa-research (faster, 15-45s, good for most queries), exa-research-pro (more comprehensive, 45s-2min, for complex topics), or exa-research-fast (fastest, lightest). Default: exa-research
    let model: ExaResearchModel?

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = arguments.model?.rawValue ?? "exa-research"
    let prompt = arguments.instructions
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
