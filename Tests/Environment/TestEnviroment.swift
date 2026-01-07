import Foundation

@testable import Core

extension Environment {
  static var testValue: Environment {
    with(Environment.liveValue) {
      $0.config = { .testValue }
    }
  }
}

extension Config {
  fileprivate static var testValue: Config {
    with(Config.liveValue) {
      $0.poeAPIKey = {
        ProcessInfo.processInfo.environment["POE_API_KEY"]
          ?? "your-hard-coded-api-key-here"
      }
    }
  }
}
