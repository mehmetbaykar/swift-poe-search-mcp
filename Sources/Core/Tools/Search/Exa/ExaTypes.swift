import Foundation
import FastMCP

@Schemable
enum ExaOperation: String, Codable, Sendable, CaseIterable {
  case search
  case similar
  case contents
  case code
}

@Schemable
enum ExaSearchType: String, Codable, Sendable, CaseIterable {
  case auto
  case neural
  case deep
  case fast
}

@Schemable
enum ExaCategory: String, Codable, Sendable, CaseIterable {
  case none = ""
  case company
  case researchPaper = "research paper"
  case news
  case pdf
  case github
  case tweet
  case personalSite = "personal site"
  case linkedinProfile = "linkedin profile"
  case financialReport = "financial report"
}

@Schemable
enum ExaLivecrawl: String, Codable, Sendable, CaseIterable {
  case fallback
  case never
  case always
  case preferred
}

@Schemable
enum ExaResearchModel: String, Codable, Sendable, CaseIterable {
  case exaResearch = "exa-research"
  case exaResearchPro = "exa-research-pro"
  case exaResearchFast = "exa-research-fast"
}

@Schemable
enum ExaCodeTokens: String, Codable, Sendable, CaseIterable {
  case dynamic
  case t5000 = "5000"
  case t10000 = "10000"
  case t20000 = "20000"
}

@Schemable
enum ExaLinkedinSearchType: String, Codable, Sendable, CaseIterable {
  case profiles
  case companies
  case all
}
