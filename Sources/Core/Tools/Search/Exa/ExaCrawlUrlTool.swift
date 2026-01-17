import Foundation
import FastMCP

struct ExaCrawlUrlTool: MCPTool {
  let name = "exa_crawl_url"
  let description: String? =
    "Extract and crawl content from specific URLs using Exa AI - retrieves full text content, metadata, and structured information from web pages. Ideal for extracting detailed content from known URLs."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// URL to crawl and extract content from
    let url: String

    /// Maximum characters to extract (default: 3000)
    let maxCharacters: Int?

    /// Fetch page text content (default: true)
    let returnText: Bool?

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

    /// When to fetch fresh content: fallback, never, always, preferred (default: preferred for crawling)
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

    extraBody["operation"] = "contents"
    extraBody["livecrawl"] = arguments.livecrawl?.rawValue ?? "preferred"

    if let v = arguments.maxCharacters { extraBody["text_max_chars"] = String(v) }
    if let v = arguments.returnText { extraBody["return_text"] = v }
    if let v = arguments.includeHtmlTags { extraBody["include_html_tags"] = v }
    if let v = arguments.returnHighlights { extraBody["return_highlights"] = v }
    if let v = arguments.highlightsSentences { extraBody["highlights_sentences"] = v }
    if let v = arguments.highlightsPerUrl { extraBody["highlights_per_url"] = v }
    if let v = arguments.highlightsQuery, !v.isEmpty { extraBody["highlights_query"] = v }
    if let v = arguments.returnSummary { extraBody["return_summary"] = v }
    if let v = arguments.summaryQuery, !v.isEmpty { extraBody["summary_query"] = v }
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
