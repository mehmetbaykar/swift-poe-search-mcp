import Foundation
import MCP

public struct TransportProvider: Sendable {
  public var get: @Sendable () -> Transport
}

extension TransportProvider {
  static var liveValue: TransportProvider {
    .init(get: {
      let transport = StdioTransport()
      return transport
    })
  }
}
