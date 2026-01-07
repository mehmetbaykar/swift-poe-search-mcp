import Foundation
import MCPToolkit

struct ExaFindSimilarTool: MCPTool {
  let name = "exa_find_similar"
  let description: String? =
    "Find similar web pages to a given URL using Exa AI - discovers pages with similar content, topics, or themes. Useful for competitive analysis, research expansion, and finding related resources."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// URL to find similar pages for
    let url: String

    /// Number of similar pages to find (1-100, default: 10)
    let numResults: Int?

    /// Filter by content category
    let category: ExaCategory?

    /// Comma-separated domains to include in results (e.g., "github.com,stackoverflow.com")
    let includeDomains: String?

    /// Comma-separated domains to exclude from results
    let excludeDomains: String?

    /// Fetch page text content (default: true)
    let returnText: Bool?

    /// Limit text length (empty = unlimited)
    let textMaxChars: String?

    /// Preserve HTML structure in results
    let includeHtmlTags: Bool?

    /// Get AI-selected key snippets from results
    let returnHighlights: Bool?

    /// Number of sentences in each highlight (1-10, default: 3)
    let highlightsSentences: Int?

    /// Number of highlights per result (1-10, default: 3)
    let highlightsPerUrl: Int?

    /// Guide highlight selection with this query
    let highlightsQuery: String?

    /// Get AI-generated summaries of results
    let returnSummary: Bool?

    /// Guide summary generation with this query
    let summaryQuery: String?

    /// When to fetch fresh content: fallback (default), never, always, preferred
    let livecrawl: ExaLivecrawl?

    /// Number of linked subpages to fetch (0-10, default: 0)
    let subpages: Int?

    /// Keyword to find specific subpages
    let subpageTarget: String?

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "exa-search"

    let prompt = arguments.url

    var extraBody: [String: Any] = [:]

    extraBody["operation"] = "similar"

    if let v = arguments.numResults { extraBody["num_results"] = v }
    if let v = arguments.category { extraBody["category"] = v.rawValue }
    if let v = arguments.includeDomains, !v.isEmpty { extraBody["include_domains"] = v }
    if let v = arguments.excludeDomains, !v.isEmpty { extraBody["exclude_domains"] = v }
    if let v = arguments.returnText { extraBody["return_text"] = v }
    if let v = arguments.textMaxChars, !v.isEmpty { extraBody["text_max_chars"] = v }
    if let v = arguments.includeHtmlTags { extraBody["include_html_tags"] = v }
    if let v = arguments.returnHighlights { extraBody["return_highlights"] = v }
    if let v = arguments.highlightsSentences { extraBody["highlights_sentences"] = v }
    if let v = arguments.highlightsPerUrl { extraBody["highlights_per_url"] = v }
    if let v = arguments.highlightsQuery, !v.isEmpty { extraBody["highlights_query"] = v }
    if let v = arguments.returnSummary { extraBody["return_summary"] = v }
    if let v = arguments.summaryQuery, !v.isEmpty { extraBody["summary_query"] = v }
    if let v = arguments.livecrawl { extraBody["livecrawl"] = v.rawValue }
    if let v = arguments.subpages { extraBody["subpages"] = v }
    if let v = arguments.subpageTarget, !v.isEmpty { extraBody["subpage_target"] = v }

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
