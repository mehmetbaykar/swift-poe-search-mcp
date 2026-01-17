import Foundation
import FastMCP

@Schemable
public struct PoeMessage: Codable, Sendable {
  public let role: String
  public let content: String

  public init(role: String, content: String) {
    self.role = role
    self.content = content
  }
}

public struct PoeChatResponse: Sendable {
  public let content: String
  public let citations: [String]?
  public let usage: PoeUsage?

  public init(content: String, citations: [String]? = nil, usage: PoeUsage? = nil) {
    self.content = content
    self.citations = citations
    self.usage = usage
  }
}

public struct PoeUsage: Sendable {
  public let promptTokens: Int
  public let completionTokens: Int
  public let totalTokens: Int

  public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
    self.promptTokens = promptTokens
    self.completionTokens = completionTokens
    self.totalTokens = totalTokens
  }
}

struct PoeChatCompletionResponse: Decodable {
  struct Choice: Decodable {
    struct Message: Decodable {
      let content: String
    }
    let message: Message
  }

  struct Usage: Decodable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
  }

  let choices: [Choice]
  let citations: [String]?
  let usage: Usage?
}

public enum PoeError: Error, LocalizedError {
  case missingAPIKey
  case invalidURL
  case httpError(statusCode: Int, message: String)
  case decodingError(String)
  case networkError(String)
  case timeout(Int)
  case emptyResponse

  public var errorDescription: String? {
    switch self {
    case .missingAPIKey:
      return "POE_API_KEY environment variable is required"
    case .invalidURL:
      return "Invalid API URL configuration"
    case .httpError(let code, let message):
      switch code {
      case 401: return "Invalid API key"
      case 402: return "Insufficient credits"
      case 404: return "Model not found"
      case 429: return "Rate limit exceeded"
      default: return "API error (\(code)): \(message)"
      }
    case .decodingError(let detail):
      return "Failed to parse API response: \(detail)"
    case .networkError(let detail):
      return "Network error: \(detail)"
    case .timeout(let ms):
      return "Request timeout after \(ms)ms. Consider increasing POE_TIMEOUT_MS."
    case .emptyResponse:
      return "Invalid API response: missing or empty choices array"
    }
  }
}
