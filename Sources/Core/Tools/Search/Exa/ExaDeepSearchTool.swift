import Foundation
import MCPToolkit

struct ExaDeepSearchTool: MCPTool {
  let name = "exa_deep_search"
  let description: String? =
    "Comprehensive web search using Exa AI with automatic query expansion. Uses deep search mode for thorough results across papers, news, and expert analysis. Ideal for research requiring multiple perspectives and sources."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// Natural language description of what the web search is looking for. Try to make the search query atomic - looking for a specific piece of information. May include guidance about preferred sources or freshness.
    let objective: String

    /// Optional list of keyword search queries (comma-separated). Limited to 5 entries of up to 5 words each.
    let searchQueries: String?

    /// Number of search results to return (1-100, default: 10)
    let numResults: Int?

    /// Filter by content category
    let category: ExaCategory?

    /// Display complete page content in results
    let showContent: Bool?

    /// Comma-separated domains to include
    let includeDomains: String?

    /// Comma-separated domains to exclude
    let excludeDomains: String?

    /// Text that must appear in results (up to 5 words)
    let includeText: String?

    /// Text that must NOT appear in results (up to 5 words)
    let excludeText: String?

    /// Results crawled after this date (ISO 8601)
    let startCrawlDate: String?

    /// Results crawled before this date (ISO 8601)
    let endCrawlDate: String?

    /// Content published after this date (ISO 8601)
    let startPublishedDate: String?

    /// Content published before this date (ISO 8601)
    let endPublishedDate: String?

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

    var prompt = arguments.objective
    if let queries = arguments.searchQueries, !queries.isEmpty {
      prompt += "\n\nAdditional search queries: \(queries)"
    }

    var extraBody: [String: Any] = [:]

    extraBody["operation"] = "search"
    extraBody["search_type"] = "deep"

    if let v = arguments.numResults { extraBody["num_results"] = v }
    if let v = arguments.category { extraBody["category"] = v.rawValue }
    if let v = arguments.showContent { extraBody["show_content"] = v }
    if let v = arguments.includeDomains, !v.isEmpty { extraBody["include_domains"] = v }
    if let v = arguments.excludeDomains, !v.isEmpty { extraBody["exclude_domains"] = v }
    if let v = arguments.includeText, !v.isEmpty { extraBody["include_text"] = v }
    if let v = arguments.excludeText, !v.isEmpty { extraBody["exclude_text"] = v }
    if let v = arguments.startCrawlDate, !v.isEmpty { extraBody["start_crawl_date"] = v }
    if let v = arguments.endCrawlDate, !v.isEmpty { extraBody["end_crawl_date"] = v }
    if let v = arguments.startPublishedDate, !v.isEmpty { extraBody["start_published_date"] = v }
    if let v = arguments.endPublishedDate, !v.isEmpty { extraBody["end_published_date"] = v }
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
