import Foundation

public struct Environment: Sendable {
  @TaskLocal public static var current: Environment = .liveValue

  public var config: @Sendable () -> Config
  public var loggerProvider: @Sendable () -> LoggerProvider
  public var toolProvider: @Sendable () -> ToolProvider
  public var contentStripper: @Sendable () -> ContentStripper
  public var poeAPIClient: @Sendable () -> PoeAPIClient
}

extension Environment {
  public static var liveValue: Environment {
    .init(
      config: { .liveValue },
      loggerProvider: { .liveValue },
      toolProvider: { .liveValue },
      contentStripper: { .liveValue },
      poeAPIClient: { .liveValue }
    )
  }
}
