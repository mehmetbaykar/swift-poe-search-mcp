import Foundation
import FastMCP

struct PerplexityResearchTool: MCPTool {
  let name = "perplexity_research"
  let description: String? =
    "Performs deep research using the Perplexity API. Accepts an array of messages (each with a role and content) and returns a comprehensive research response with citations."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// Array of conversation messages
    let messages: [PoeMessage]

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?

    /// Controls the computational effort. 'High' provides more thorough responses but increases costs
    let reasoningEffort: ReasoningEffort?

    /// Filter search results by source type (only 'default' is supported)
    let searchMode: SearchMode?

    /// Comma-separated domains. Exclude with '-'
    let searchDomainFilter: String?

    /// Date filter for search results
    let searchAfterDateFilter: String?

    /// Date filter for search results
    let searchBeforeDateFilter: String?

    /// Filter by last updated date
    let lastUpdatedAfterFilter: String?

    /// Filter by last updated date
    let lastUpdatedBeforeFilter: String?

    /// Two-letter ISO 3166-1 country code (currently disabled)
    let country: String?

    /// Must be provided with Longitude and Country (currently disabled)
    let latitude: String?

    /// Must be provided with Latitude and Country (currently disabled)
    let longitude: String?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "perplexity-deep-research"

    var extraBody: [String: Any] = [:]

    if let v = arguments.reasoningEffort { extraBody["reasoning_effort"] = v.rawValue }
    if let v = arguments.searchMode { extraBody["search_mode"] = v.rawValue }
    if let v = arguments.searchDomainFilter, !v.isEmpty { extraBody["search_domain_filter"] = v }
    if let v = arguments.searchAfterDateFilter, !v.isEmpty {
      extraBody["search_after_date_filter"] = v
    }
    if let v = arguments.searchBeforeDateFilter, !v.isEmpty {
      extraBody["search_before_date_filter"] = v
    }
    if let v = arguments.lastUpdatedAfterFilter, !v.isEmpty {
      extraBody["last_updated_after_filter"] = v
    }
    if let v = arguments.lastUpdatedBeforeFilter, !v.isEmpty {
      extraBody["last_updated_before_filter"] = v
    }
    if let v = arguments.country, !v.isEmpty { extraBody["country"] = v }
    if let v = arguments.latitude, !v.isEmpty { extraBody["latitude"] = v }
    if let v = arguments.longitude, !v.isEmpty { extraBody["longitude"] = v }

    do {
      let response = try await Environment.current.poeAPIClient().performChatCompletion(
        arguments.messages,
        model,
        extraBody.isEmpty ? nil : extraBody,
        !(arguments.showThinking ?? false)
      )

      var result = response.content
      if let citations = response.citations, !citations.isEmpty {
        result += "\n\nCitations:\n"
        for (index, citation) in citations.enumerated() {
          result += "[\(index + 1)] \(citation)\n"
        }
      }

      return [ToolContentItem(text: result)]
    } catch let error as PoeError {
      throw ToolError(error.localizedDescription)
    } catch {
      throw ToolError("Unexpected error: \(error.localizedDescription)")
    }
  }
}
