// swift-tools-version: 6.2
import PackageDescription

func externalDependencies() -> [Package.Dependency] {
  let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/mehmetbaykar/swift-fast-mcp.git", from: "1.0.1")
  ]
  return dependencies
}

func coreDependencies() -> [Target.Dependency] {
  return [
    .product(name: "FastMCP", package: "swift-fast-mcp")
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
