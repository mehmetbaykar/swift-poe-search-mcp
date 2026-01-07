import Foundation
import MCPToolkit

@Schemable
enum SearchContextSize: String, Codable, Sendable, CaseIterable {
  case low
  case medium
  case high
}

@Schemable
enum SearchMode: String, Codable, Sendable, CaseIterable {
  case `default`
  case academic
  case sec
}

@Schemable
enum RecencyFilter: String, Codable, Sendable, CaseIterable {
  case none
  case day
  case week
  case month
  case year
}

@Schemable
enum ReasoningEffort: String, Codable, Sendable, CaseIterable {
  case low
  case medium
  case high
}
