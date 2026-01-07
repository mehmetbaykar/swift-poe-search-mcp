import Core
import Foundation

@main
struct swift_search_mcp {
  static func main() async throws {
    let serviceGroup = await Environment.current.serviceGroupProvider().get()
    try await serviceGroup.run()
  }
}
