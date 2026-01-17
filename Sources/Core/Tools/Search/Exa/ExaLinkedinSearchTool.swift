import Foundation
import FastMCP

struct ExaLinkedinSearchTool: MCPTool {
  let name = "exa_linkedin_search"
  let description: String? =
    "Search LinkedIn profiles and companies using Exa AI - finds professional profiles, company pages, and business-related content on LinkedIn. Useful for networking, recruitment, and business research."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// LinkedIn search query (e.g., person name, company, job title)
    let query: String

    /// Type of LinkedIn content to search: profiles, companies, or all (default: all)
    let searchType: ExaLinkedinSearchType?

    /// Number of LinkedIn results to return (1-100, default: 5)
    let numResults: Int?

    /// Fetch page text content (default: true)
    let returnText: Bool?

    /// Get AI-selected key snippets from results
    let returnHighlights: Bool?

    /// Get AI-generated summaries of results
    let returnSummary: Bool?

    /// When to fetch fresh content: fallback (default), never, always, preferred
    let livecrawl: ExaLivecrawl?

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "exa-search"

    var prompt = arguments.query
    if let searchType = arguments.searchType {
      switch searchType {
      case .profiles:
        prompt += " site:linkedin.com/in/"
      case .companies:
        prompt += " site:linkedin.com/company/"
      case .all:
        break
      }
    }

    var extraBody: [String: Any] = [:]

    extraBody["operation"] = "search"
    extraBody["search_type"] = "neural"
    extraBody["include_domains"] = "linkedin.com"

    if let v = arguments.numResults {
      extraBody["num_results"] = v
    } else {
      extraBody["num_results"] = 5
    }
    if let v = arguments.returnText { extraBody["return_text"] = v }
    if let v = arguments.returnHighlights { extraBody["return_highlights"] = v }
    if let v = arguments.returnSummary { extraBody["return_summary"] = v }
    if let v = arguments.livecrawl { extraBody["livecrawl"] = v.rawValue }

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
