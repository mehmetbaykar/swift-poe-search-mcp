import Foundation
import FastMCP

struct ExaCompanyResearchTool: MCPTool {
  let name = "exa_company_research"
  let description: String? =
    "Research companies using Exa AI - finds comprehensive information about businesses, organizations, and corporations. Provides insights into company operations, news, financial information, and industry analysis."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// Name of the company to research
    let companyName: String

    /// Number of search results to return (1-100, default: 5)
    let numResults: Int?

    /// Content published after this date (ISO 8601)
    let startPublishedDate: String?

    /// Content published before this date (ISO 8601)
    let endPublishedDate: String?

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

    let prompt = "\(arguments.companyName) company information news funding financials"

    var extraBody: [String: Any] = [:]

    extraBody["operation"] = "search"
    extraBody["category"] = "company"
    extraBody["include_domains"] =
      "bloomberg.com,reuters.com,crunchbase.com,sec.gov,linkedin.com,forbes.com,businesswire.com,prnewswire.com"

    if let v = arguments.numResults {
      extraBody["num_results"] = v
    } else {
      extraBody["num_results"] = 5
    }
    if let v = arguments.startPublishedDate, !v.isEmpty { extraBody["start_published_date"] = v }
    if let v = arguments.endPublishedDate, !v.isEmpty { extraBody["end_published_date"] = v }
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
