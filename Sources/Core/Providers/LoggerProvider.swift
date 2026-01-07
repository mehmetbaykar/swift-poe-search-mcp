import Foundation
import Logging

extension Logger {
  fileprivate static var liveValue: Logger {
    let logger = Logger(label: "swift-poe-search-mcp") { label in
      var handler = StreamLogHandler.standardOutput(label: label)
      handler.logLevel = .debug
      return handler
    }
    return logger
  }
}

public struct LoggerProvider: Sendable {
  public var get: @Sendable () -> Logger
}

extension LoggerProvider {
  static var liveValue: LoggerProvider {
    .init(get: { Logger.liveValue })
  }
}

public func log(message: String, level: Logger.Level = .debug) {
  let logger = Environment.current.loggerProvider().get()
  let readableDate = readableDate()
  let message = "[\(readableDate)] => \(message)"
  logger.log(level: .debug, .init(stringLiteral: message))
}

private func readableDate() -> String {
  let date = Date()
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
  return formatter.string(from: date)
}
