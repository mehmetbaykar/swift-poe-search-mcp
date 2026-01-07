import Foundation
import MCPToolkit

func loggedTest<T: MCPTool>(
  name: String = #function,
  tool: T,
  params: T.Parameters,
  call: () async throws -> [ToolContentItem]
) async throws -> [ToolContentItem] {
  let start = Date()
  let paramsDict = describeParams(params)

  do {
    let result = try await call()
    let duration = Date().timeIntervalSince(start)
    let response = result.map { String(describing: $0) }.joined(separator: "\n")

    await TestLogger.shared.log(
      testName: name,
      toolName: tool.name,
      parameters: paramsDict,
      status: "passed",
      duration: duration,
      response: response
    )
    return result
  } catch {
    let duration = Date().timeIntervalSince(start)
    await TestLogger.shared.log(
      testName: name,
      toolName: tool.name,
      parameters: paramsDict,
      status: "failed",
      duration: duration,
      response: "",
      error: error.localizedDescription
    )
    throw error
  }
}

private func describeParams(_ params: Any) -> [String: String] {
  var result: [String: String] = [:]
  let mirror = Mirror(reflecting: params)
  for child in mirror.children {
    guard let label = child.label else { continue }
    let value = child.value
    if case Optional<Any>.none = value { continue }
    result[label] = String(describing: value)
  }
  return result
}
