import Testing

@testable import Core

extension Trait where Self == ConditionTrait {
  private static func enabledFor(_ provider: Provider) -> Self {
    enabled(
      if: Environment.current.config().isProviderEnabled(provider),
      "\(provider.rawValue) provider disabled (set ENABLED_PROVIDERS to enable)"
    )
  }

  static var enabledForExa: Self { enabledFor(.exa) }
  static var enabledForPerplexity: Self { enabledFor(.perplexity) }
  static var enabledForReka: Self { enabledFor(.reka) }
  static var enabledForLinkup: Self { enabledFor(.linkup) }
}
