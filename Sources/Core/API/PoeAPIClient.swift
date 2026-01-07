import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct PoeAPIClient: Sendable {
  public var performChatCompletion:
    @Sendable (
      _ messages: [PoeMessage],
      _ model: String,
      _ extraBody: [String: Any]?,
      _ showThinking: Bool
    ) async throws -> PoeChatResponse
}

extension PoeAPIClient {

  public static var liveValue: PoeAPIClient {
    let config = Environment.current.config()

    return .init(performChatCompletion: { messages, model, extraBody, showThinking in
      guard let apiKey = config.poeAPIKey() else {
        throw PoeError.missingAPIKey
      }

      guard let url = URL(string: "\(config.poeBaseURL())/chat/completions") else {
        throw PoeError.invalidURL
      }

      var body: [String: Any] = [
        "model": model,
        "messages": messages.map { ["role": $0.role, "content": $0.content] },
        "stream": false,
      ]

      if let extraBody = extraBody, !extraBody.isEmpty {
        body["extra_body"] = extraBody
      }

      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
      let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
      request.httpBody = jsonData
      request.timeoutInterval = TimeInterval(config.poeTimeoutMS()) / 1000.0

      let (data, response): (Data, URLResponse)
      do {
        (data, response) = try await URLSession.shared.data(for: request)
      } catch let error as URLError where error.code == .timedOut {
        throw PoeError.timeout(config.poeTimeoutMS())
      } catch {
        throw PoeError.networkError(error.localizedDescription)
      }

      guard let httpResponse = response as? HTTPURLResponse else {
        throw PoeError.networkError("Invalid response type")
      }

      guard (200...299).contains(httpResponse.statusCode) else {
        let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
        throw PoeError.httpError(statusCode: httpResponse.statusCode, message: errorMessage)
      }

      let decoded: PoeChatCompletionResponse
      do {
        decoded = try JSONDecoder().decode(PoeChatCompletionResponse.self, from: data)
      } catch {
        throw PoeError.decodingError(error.localizedDescription)
      }

      guard let firstChoice = decoded.choices.first else {
        throw PoeError.emptyResponse
      }

      var content = firstChoice.message.content

      if !showThinking {
        content = Environment.current.contentStripper().strip(content)
      }

      let usage: PoeUsage?
      if let u = decoded.usage {
        usage = PoeUsage(
          promptTokens: u.prompt_tokens,
          completionTokens: u.completion_tokens,
          totalTokens: u.total_tokens
        )
      } else {
        usage = nil
      }

      return PoeChatResponse(
        content: content,
        citations: decoded.citations,
        usage: usage
      )
    })
  }
}
