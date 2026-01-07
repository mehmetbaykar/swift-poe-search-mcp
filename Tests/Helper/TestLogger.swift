import Foundation
import MCPToolkit

actor TestLogger {
  static let shared = TestLogger()
  private let filePath = "TestResults.json"

  struct TestResult: Codable {
    let testName: String
    let toolName: String
    let parameters: [String: String]
    let status: String
    let duration: Double
    let response: String
    let error: String?
    let timestamp: String
  }

  func log(
    testName: String,
    toolName: String,
    parameters: [String: String],
    status: String,
    duration: TimeInterval,
    response: String,
    error: String? = nil
  ) {
    let result = TestResult(
      testName: testName,
      toolName: toolName,
      parameters: parameters,
      status: status,
      duration: duration,
      response: response,
      error: error,
      timestamp: ISO8601DateFormatter().string(from: Date())
    )
    appendToFile(result)
  }

  private func appendToFile(_ result: TestResult) {
    let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
      .appendingPathComponent(filePath)

    var results: [TestResult] = []

    if FileManager.default.fileExists(atPath: fileURL.path),
      let existingData = try? Data(contentsOf: fileURL),
      let existingResults = try? JSONDecoder().decode([TestResult].self, from: existingData)
    {
      results = existingResults
    }

    results.append(result)

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

    if let jsonData = try? encoder.encode(results) {
      try? jsonData.write(to: fileURL)
    }
  }

  func clear() {
    let fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
      .appendingPathComponent(filePath)
    try? FileManager.default.removeItem(at: fileURL)
  }
}
