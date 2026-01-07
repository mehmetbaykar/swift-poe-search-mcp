import Foundation

@testable import Core

enum TestPrompts {
  // MARK: - Simple Factual (fastest, most deterministic)
  static let factual = PoeMessage(
    role: "user",
    content: "What is the capital of France?"
  )

  // MARK: - Math (fully deterministic)
  static let math = PoeMessage(
    role: "user",
    content: "What is 2 + 2?"
  )

  // MARK: - Technical (for code/API tools)
  static let technical = PoeMessage(
    role: "user",
    content: "What is the Swift programming language?"
  )

  // MARK: - Research (for deep research tools)
  static let research = PoeMessage(
    role: "user",
    content: "Compare Python and JavaScript"
  )

  // MARK: - Claim Verification
  static let claim = "The Earth orbits the Sun"

  // MARK: - URL for crawl/similar tools
  static let url = "https://swift.org"
  static let githubUrl = "https://github.com/apple/swift"

  // MARK: - Company for research tools
  static let company = "Apple Inc"

  // MARK: - Search queries
  static let searchQuery = "Swift programming language"
  static let codeQuery = "SwiftUI State property wrapper"

  // MARK: - Find Similar
  static let findSimilarTarget = "Claude Opus 4.5"
  static let findSimilarAttribute = "color"

  // MARK: - Deep research
  static let deepResearchObjective = "Latest Swift 6.2 concurrency features"
  static let deepResearchInstructions = "Compare Swift and Kotlin for mobile development"

  // MARK: - LinkedIn
  static let linkedinQuery = "Swift developer"

  // MARK: - Helper to create message array
  static func messages(_ prompt: PoeMessage) -> [PoeMessage] {
    [prompt]
  }
}
