import Foundation
import Logging

public struct LoggerProvider: Sendable {
  public var get: @Sendable () -> Logger
}

extension LoggerProvider {
  static var liveValue: LoggerProvider {
    .init(get: {
      var logger = Logger(label: "swift-poe-search-mcp")
      logger.logLevel = .debug
      return logger
    })
  }
}
