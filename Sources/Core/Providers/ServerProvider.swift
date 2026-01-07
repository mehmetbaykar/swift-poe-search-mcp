import Foundation
import MCP

public struct ServerProvider: Sendable {
  public var get: @Sendable () async -> Server
}

extension ServerProvider {
  static var liveValue: ServerProvider {
    .init(get: {
      let tools = Environment.current.toolProvider().get()
      let server = Server(
        name: "Swift Version Server", version: "1.0.0",
        capabilities: .init(tools: .init(listChanged: false)))

      await server.register(tools: tools)

      return server
    }
    )
  }
}
