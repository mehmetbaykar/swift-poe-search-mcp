import Core
import FastMCP

@main
struct swift_search_mcp {
  static func main() async throws {
    let tools = Environment.current.toolProvider().get()
    let logger = Environment.current.loggerProvider().get()

    try await FastMCP.builder()
      .name("swift-poe-search-mcp")
      .version("1.1.0")
      .addTools(tools)
      .transport(.stdio)
      .logger(logger)
      .run()
  }
}
