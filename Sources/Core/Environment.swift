import Foundation
import MCP

public struct Environment: Sendable {
  @TaskLocal public static var current: Environment = .liveValue

  public var config: @Sendable () -> Config
  public var loggerProvider: @Sendable () -> LoggerProvider
  public var toolProvider: @Sendable () -> ToolProvider
  public var serverProvider: @Sendable () -> ServerProvider
  public var serviceProvider: @Sendable () -> ServiceProvider
  public var serviceGroupProvider: @Sendable () -> ServiceGroupProvider
  public var transportProvider: @Sendable () -> TransportProvider
  public var contentStripper: @Sendable () -> ContentStripper
  public var poeAPIClient: @Sendable () -> PoeAPIClient
}

extension Environment {
  public static var liveValue: Environment {
    .init(
      config: { .liveValue },
      loggerProvider: { .liveValue },
      toolProvider: { .liveValue },
      serverProvider: { .liveValue },
      serviceProvider: { .liveValue },
      serviceGroupProvider: { .liveValue },
      transportProvider: { .liveValue },
      contentStripper: { .liveValue },
      poeAPIClient: { .liveValue }
    )
  }
}
