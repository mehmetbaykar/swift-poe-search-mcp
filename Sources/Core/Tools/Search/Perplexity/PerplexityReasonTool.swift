import Foundation
import MCPToolkit

struct PerplexityReasonTool: MCPTool {
  let name = "perplexity_reason"
  let description: String? =
    "Performs reasoning tasks using the Perplexity API. Accepts an array of messages (each with a role and content) and returns a well-reasoned response using the sonar-reasoning-pro model."

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    /// Array of conversation messages
    let messages: [PoeMessage]

    /// If true, shows <think>...</think> tags in the response. Default is false
    let showThinking: Bool?

    /// Higher context gives better answers but increases the base fee
    let searchContextSize: SearchContextSize?

    /// Filter search results by source type
    let searchMode: SearchMode?

    /// Comma-separated domains. Exclude with '-'. Max 20
    let searchDomainFilter: String?

    /// Comma-separated ISO 639-1 language codes (2 letters). Max 10
    let searchLanguageFilter: String?

    /// Relative date filter. Cannot be combined with specific dates
    let searchRecencyFilter: RecencyFilter?

    /// Use exact publication date (mutually exclusive with Recency)
    let searchAfterDate: String?

    /// Use exact publication date (mutually exclusive with Recency)
    let searchBeforeDate: String?

    /// Two-letter ISO 3166-1 country code
    let country: String?

    /// State/Province name
    let region: String?

    /// City name
    let city: String?

    /// Must be provided with Longitude and Country
    let latitude: String?

    /// Must be provided with Latitude and Country
    let longitude: String?

    /// Include images in search results
    let returnImages: Bool?

    /// Include videos in search results
    let returnVideos: Bool?

    /// Comma-separated domains for images. Exclude with '-'. Max 10
    let imageDomainFilter: String?

    /// Comma-separated formats: gif, jpg, png, webp
    let imageFormatFilter: String?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "perplexity-sonar-rsn-pro"

    var extraBody: [String: Any] = [:]

    if let v = arguments.searchContextSize { extraBody["search_context_size"] = v.rawValue }
    if let v = arguments.searchMode { extraBody["search_mode"] = v.rawValue }
    if let v = arguments.searchDomainFilter, !v.isEmpty { extraBody["search_domain_filter"] = v }
    if let v = arguments.searchLanguageFilter, !v.isEmpty {
      extraBody["search_language_filter"] = v
    }
    if let v = arguments.searchRecencyFilter, v != .none {
      extraBody["search_recency_filter"] = v.rawValue
    }
    if let v = arguments.searchAfterDate, !v.isEmpty { extraBody["search_after_date"] = v }
    if let v = arguments.searchBeforeDate, !v.isEmpty { extraBody["search_before_date"] = v }
    if let v = arguments.country, !v.isEmpty { extraBody["country"] = v }
    if let v = arguments.region, !v.isEmpty { extraBody["region"] = v }
    if let v = arguments.city, !v.isEmpty { extraBody["city"] = v }
    if let v = arguments.latitude, !v.isEmpty { extraBody["latitude"] = v }
    if let v = arguments.longitude, !v.isEmpty { extraBody["longitude"] = v }
    if let v = arguments.returnImages { extraBody["return_images"] = v }
    if let v = arguments.returnVideos { extraBody["return_videos"] = v }
    if let v = arguments.imageDomainFilter, !v.isEmpty { extraBody["image_domain_filter"] = v }
    if let v = arguments.imageFormatFilter, !v.isEmpty { extraBody["image_format_filter"] = v }

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
