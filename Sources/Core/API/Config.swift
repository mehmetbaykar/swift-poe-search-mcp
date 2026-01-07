import Foundation

public enum Provider: String, CaseIterable, Sendable {
  case exa
  case perplexity
  case reka
  case linkup
}

public struct Config: Sendable {
  public var enabledProviders: @Sendable () -> Set<Provider>
  public var poeBaseURL: @Sendable () -> String
  public var poeAPIKey: @Sendable () -> String?
  public var poeTimeoutMS: @Sendable () -> Int
}

extension Config {
  public func isProviderEnabled(_ provider: Provider) -> Bool {
    enabledProviders().contains(provider)
  }
}

extension Config {

  public static var liveValue: Config {
    let defaultEnabledProviders: Set<Provider> = [.perplexity, .reka, .linkup, .exa]
    return .init(
      enabledProviders: {
        guard let envValue = ProcessInfo.processInfo.environment["ENABLED_PROVIDERS"] else {
          return defaultEnabledProviders
        }
        if envValue.lowercased() == "all" {
          return Set(Provider.allCases)
        }
        if envValue.isEmpty {
          return []
        }
        let providers = envValue.split(separator: ",")
          .compactMap {
            Provider(rawValue: String($0).trimmingCharacters(in: .whitespaces).lowercased())
          }
        return Set(providers)
      },
      poeBaseURL: {
        ProcessInfo.processInfo.environment["POE_BASE_URL"] ?? "https://api.poe.com/v1"
      },
      poeAPIKey: { ProcessInfo.processInfo.environment["POE_API_KEY"] },
      poeTimeoutMS: {
        if let envValue = ProcessInfo.processInfo.environment["POE_TIMEOUT_MS"],
          let ms = Int(envValue)
        {
          return ms
        }
        return 600000
      }
    )
  }
}
