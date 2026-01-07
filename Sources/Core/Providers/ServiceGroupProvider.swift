import Foundation
import MCP
import ServiceLifecycle

public struct ServiceGroupProvider: Sendable {
  public var get: @Sendable () async -> ServiceGroup
}

extension ServiceGroupProvider {
  static var liveValue: ServiceGroupProvider {
    .init(get: {
      let logger = Environment.current.loggerProvider().get()
      let mcpService = await Environment.current.serviceProvider().get()

      let serviceGroup = ServiceGroup(
        services: [mcpService],
        gracefulShutdownSignals: [.sigterm, .sigint],
        logger: logger
      )

      return serviceGroup
    })
  }
}
