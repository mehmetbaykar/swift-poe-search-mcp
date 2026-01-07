import Testing

@testable import Core

struct TestEnvironmentTrait: SuiteTrait, TestScoping {
  func provideScope(
    for test: Test,
    testCase: Test.Case?,
    performing function: @Sendable () async throws -> Void
  ) async throws {
    try await Environment.$current.withValue(.testValue) {
      try await function()
    }
  }
}

extension Trait where Self == TestEnvironmentTrait {
  static var testEnvironment: Self { .init() }
}
