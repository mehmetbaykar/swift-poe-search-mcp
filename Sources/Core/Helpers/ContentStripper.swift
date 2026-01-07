import Foundation

public struct ContentStripper: Sendable {
  public var strip: @Sendable (String) -> String
}

extension ContentStripper {
  static var liveValue: ContentStripper {
    .init(strip: { content in
      var result = content

      if let thinkRegex = try? NSRegularExpression(
        pattern: "<think>[\\s\\S]*?</think>", options: [])
      {
        let range = NSRange(result.startIndex..., in: result)
        result = thinkRegex.stringByReplacingMatches(
          in: result, options: [], range: range, withTemplate: "")
      }

      let lines = result.components(separatedBy: "\n")
      var contentStartIndex = 0

      for (index, line) in lines.enumerated() {
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        if trimmed.hasPrefix("Thinking") {
          continue
        }

        if trimmed.hasPrefix("> *") && trimmed.hasSuffix("*") {
          continue
        }

        if trimmed.isEmpty && contentStartIndex == 0 {
          continue
        }

        contentStartIndex = index
        break
      }

      if contentStartIndex > 0 {
        result = lines[contentStartIndex...].joined(separator: "\n")
      }

      return result.trimmingCharacters(in: .whitespacesAndNewlines)
    })
  }
}
