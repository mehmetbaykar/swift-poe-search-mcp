import Foundation
import Logging
import MCP
import ServiceLifecycle

public struct MCPService: Service {
  let server: Server
  let transport: Transport
  var logger: Logger { Environment.current.loggerProvider().get() }

  init(server: Server, transport: Transport) {
    self.server = server
    self.transport = transport
  }

  public func run() async throws {
    logger.info("Starting swift search mcp server")
    try await server.start(transport: transport)
    logger.info("Swift search mcp server started")
    await server.waitUntilCompleted()
  }

  func shutdown() async throws {
    logger.info("Stopping swift search mcp server")
    await server.stop()
  }
}

public struct ServiceProvider: Sendable {
  public var get: @Sendable () async -> MCPService
}

extension ServiceProvider {
  static var liveValue: ServiceProvider {
    .init(get: {
      let server = await Environment.current.serverProvider().get()
      let transport = Environment.current.transportProvider().get()

      let service = MCPService(server: server, transport: transport)
      return service
    }
    )
  }
}
