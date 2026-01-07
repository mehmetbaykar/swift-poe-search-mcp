// swift-tools-version: 6.2
import PackageDescription

func externalDependencies() -> [Package.Dependency] {
  let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/modelcontextprotocol/swift-sdk", from: "0.10.2"),
    .package(url: "https://github.com/swift-server/swift-service-lifecycle.git", from: "2.9.1"),
    .package(url: "https://github.com/mehmetbaykar/swift-mcp-toolkit.git", from: "0.2.1"),
  ]
  return dependencies
}

func coreDependencies() -> [Target.Dependency] {
  return [
    .product(name: "MCP", package: "swift-sdk"),
    .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
    .product(name: "MCPToolkit", package: "swift-mcp-toolkit"),
  ]
}

func executableDependencies() -> [Target.Dependency] {
  return [
    "Core"
  ]
}

func testDependencies() -> [Target.Dependency] {
  let dependencies: [Target.Dependency] = [
    "Core"
  ]
  return dependencies
}

func executableTarget() -> [PackageDescription.Target] {
  return [
    .executableTarget(
      name: "swift-poe-search-mcp",
      dependencies: executableDependencies()
    )
  ]
}

func coreTarget() -> [PackageDescription.Target] {
  return [
    .target(
      name: "Core",
      dependencies: coreDependencies()
    )
  ]
}

func testTarget() -> [PackageDescription.Target] {
  return [
    .testTarget(
      name: "Tests",
      dependencies: testDependencies()
    )
  ]
}

let package = Package(
  name: "swift-poe-search-mcp",
  platforms: [.macOS(.v14)],
  dependencies: externalDependencies(),
  targets: executableTarget() + coreTarget() + testTarget())
