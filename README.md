# Swift Poe Search MCP

A Swift MCP (Model Context Protocol) server providing AI-powered search and research tools via the Poe API proxy. Supports 4 providers with 16 specialized tools.

<p align="center">
If you found this helpful, you can support more open source work!
<br><br>
<a href="https://buymeacoffee.com/mehmetbaykar" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60"></a>
</p>

---

## Overview

This server acts as a bridge between MCP clients and multiple AI/search providers through Poe's unified API:

| Provider | Tools | Description |
|----------|-------|-------------|
| Perplexity | 3 | Web search with citations, reasoning, deep research |
| Reka | 3 | Agentic research, fact-checking, similarity finding |
| Exa | 9 | Neural search, code context, company research, crawling |
| Linkup | 1 | #1 ranked factual accuracy on OpenAI's SimpleQA |

## Quick Start

### Requirements

- Poe subscription with API access
- API key from [poe.com/api_key](https://poe.com/api_key)
- **Linux**: Ubuntu 20.04+ or Debian 11+, requires `apt-get install libcurl4`
- **macOS**: macOS 14+ (Sonoma), Intel Macs supported via Rosetta
- **Swift**: 6.2+ (for building from source)

### Installation

**Via NPM (no build required):**
```bash
npx @mehmetbaykar/swift-poe-search-mcp@latest
```

**Via Swift (build from source):**
```bash
git clone https://github.com/mehmetbaykar/swift-poe-search-mcp.git
cd swift-poe-search-mcp
swift build -c release
```

### Configuration

```bash
# Required
export POE_API_KEY=your_api_key

# Optional
export POE_BASE_URL=https://api.poe.com/v1  # default
export POE_TIMEOUT_MS=600000                 # default: 10 minutes
export ENABLED_PROVIDERS=perplexity,reka,exa,linkup  # default: all
```

### MCP Client Configuration

#### Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "swift-poe-search": {
      "command": "npx",
      "args": ["@mehmetbaykar/swift-poe-search-mcp@latest"],
      "env": {
        "POE_API_KEY": "your_api_key"
      }
    }
  }
}
```

#### Cursor

Add to `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project):

```json
{
  "mcpServers": {
    "swift-poe-search": {
      "command": "npx",
      "args": ["@mehmetbaykar/swift-poe-search-mcp@latest"],
      "env": {
        "POE_API_KEY": "your_api_key"
      }
    }
  }
}
```

#### Claude Code CLI

Add to `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "swift-poe-search": {
      "command": "npx",
      "args": ["@mehmetbaykar/swift-poe-search-mcp@latest"],
      "env": {
        "POE_API_KEY": "your_api_key"
      }
    }
  }
}
```

### Testing with MCP Inspector

```bash
POE_API_KEY=your_key npx @modelcontextprotocol/inspector@latest swift run
```

---

## Available Tools

### Perplexity Tools

#### `perplexity_ask`

Conversational web search using Sonar API with 200k context.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| messages | [Message] | required | Conversation messages |
| searchContextSize | enum | low | low, medium, high |
| searchMode | enum | default | default, academic, sec |
| searchDomainFilter | string | "" | Comma-separated domains (prefix with `-` to exclude) |
| searchLanguageFilter | string | "" | ISO 639-1 codes (max 10) |
| searchRecencyFilter | enum | none | none, day, week, month, year |
| searchAfterDate | string | "" | Publication date filter |
| searchBeforeDate | string | "" | Publication date filter |
| country | string | "" | ISO 3166-1 alpha-2 code |
| region | string | "" | State/Province name |
| city | string | "" | City name |
| latitude | string | "" | Requires longitude + country |
| longitude | string | "" | Requires latitude + country |
| returnImages | bool | false | Include images |
| returnVideos | bool | false | Include videos |
| imageDomainFilter | string | "" | Domains for images (max 10) |
| imageFormatFilter | string | "" | gif, jpg, png, webp |

#### `perplexity_reason`

R1-1776 reasoning with web search via Sonar Reasoning Pro (128k context).

All parameters from `perplexity_ask` plus:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| showThinking | bool | false | Show `<think>...</think>` reasoning tags |

#### `perplexity_research`

Deep multi-step research via Perplexity Deep Research (128k context).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| messages | [Message] | required | Conversation messages |
| showThinking | bool | false | Show reasoning tags |
| reasoningEffort | enum | low | low, medium, high |
| searchMode | enum | default | Only "default" supported |
| searchDomainFilter | string | "" | Comma-separated domains |
| searchAfterDateFilter | string | "" | Date filter |
| searchBeforeDateFilter | string | "" | Date filter |
| lastUpdatedAfterFilter | string | "" | Update date filter |
| lastUpdatedBeforeFilter | string | "" | Update date filter |

---

### Reka Tools

#### `reka_research`

Autonomous research agent with multi-hop web synthesis.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| messages | [Message] | required | Conversation messages |
| showThinking | bool | false | Show reasoning tags |

#### `reka_verify_claim`

Fact-check claims with structured verdict, confidence, and reasoning.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| claim | string | required | Statement to verify |
| showThinking | bool | false | Show reasoning tags |

#### `reka_find_similar`

Find items similar to a target based on specific attributes.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| target | string | required | Item to find similarities for |
| attribute | string | required | Characteristic to compare (e.g., "functionality", "style") |
| showThinking | bool | false | Show reasoning tags |

---

### Exa Tools

#### `exa_web_search`

Real-time web search with extensive filtering options.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| query | string | required | Search query |
| numResults | int | 10 | Results count (1-100) |
| searchType | enum | auto | auto, neural, deep, fast |
| category | enum | "" | company, research paper, news, pdf, github, tweet, etc. |
| showContent | bool | false | Display full page content |
| includeDomains | string | "" | Domains to include |
| excludeDomains | string | "" | Domains to exclude |
| includeText | string | "" | Required text (max 5 words) |
| excludeText | string | "" | Excluded text (max 5 words) |
| startCrawlDate | string | "" | ISO 8601 date |
| endCrawlDate | string | "" | ISO 8601 date |
| startPublishedDate | string | "" | ISO 8601 date |
| endPublishedDate | string | "" | ISO 8601 date |
| returnText | bool | true | Fetch page text |
| textMaxChars | string | "" | Limit text length |
| includeHtmlTags | bool | false | Preserve HTML structure |
| returnHighlights | bool | false | AI-selected key snippets |
| highlightsSentences | int | 3 | Sentences per highlight (1-10) |
| highlightsPerUrl | int | 3 | Highlights per result (1-10) |
| highlightsQuery | string | "" | Guide highlight selection |
| returnSummary | bool | false | AI-generated summaries |
| summaryQuery | string | "" | Guide summary generation |
| livecrawl | enum | fallback | fallback, never, always, preferred |
| subpages | int | 0 | Linked subpages (0-10) |
| subpageTarget | string | "" | Keyword for subpages |
| showThinking | bool | false | Show reasoning tags |

#### `exa_deep_search`

Comprehensive search with automatic query expansion using deep mode.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| objective | string | required | Natural language search description |
| searchQueries | string | "" | Optional keyword queries (comma-separated, max 5) |

Plus all filtering parameters from `exa_web_search`.

#### `exa_code_context`

Code examples and API documentation search.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| query | string | required | Code/API search query |
| codeTokens | enum | dynamic | dynamic, 5000, 10000, 20000 |
| showThinking | bool | false | Show reasoning tags |

#### `exa_crawl_url`

Extract content from specific URLs.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| url | string | required | URL to crawl |
| maxCharacters | int | 3000 | Max characters to extract |
| returnText | bool | true | Fetch page text |
| includeHtmlTags | bool | false | Preserve HTML |
| returnHighlights | bool | false | Key snippets |
| highlightsSentences | int | 3 | Sentences per highlight |
| highlightsPerUrl | int | 3 | Highlights per result |
| highlightsQuery | string | "" | Guide highlights |
| returnSummary | bool | false | AI summaries |
| summaryQuery | string | "" | Guide summaries |
| livecrawl | enum | preferred | fallback, never, always, preferred |
| subpages | int | 0 | Linked subpages |
| subpageTarget | string | "" | Subpage keyword |
| showThinking | bool | false | Show reasoning tags |

#### `exa_find_similar`

Find pages similar to a given URL.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| url | string | required | Source URL |
| numResults | int | 10 | Results count (1-100) |
| category | enum | "" | Content category filter |
| includeDomains | string | "" | Domains to include |
| excludeDomains | string | "" | Domains to exclude |

Plus content extraction parameters (returnText, highlights, summaries, livecrawl, subpages).

#### `exa_company_research`

Company research with curated business sources.

Pre-configured domains: bloomberg.com, reuters.com, crunchbase.com, sec.gov, linkedin.com, forbes.com, businesswire.com, prnewswire.com

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| companyName | string | required | Company to research |
| numResults | int | 5 | Results count |
| startPublishedDate | string | "" | ISO 8601 date |
| endPublishedDate | string | "" | ISO 8601 date |
| returnText | bool | true | Fetch page text |
| returnHighlights | bool | false | Key snippets |
| returnSummary | bool | false | AI summaries |
| livecrawl | enum | fallback | Content freshness |
| showThinking | bool | false | Show reasoning tags |

#### `exa_linkedin_search`

LinkedIn-specific search for profiles and companies.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| query | string | required | LinkedIn search query |
| searchType | enum | all | profiles, companies, all |
| numResults | int | 5 | Results count |
| returnText | bool | true | Fetch page text |
| returnHighlights | bool | false | Key snippets |
| returnSummary | bool | false | AI summaries |
| livecrawl | enum | fallback | Content freshness |
| showThinking | bool | false | Show reasoning tags |

#### `exa_quick_answer`

Quick LLM answer with search-backed citations.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| query | string | required | Question to answer |
| showText | bool | false | Show text under citations |
| showThinking | bool | false | Show reasoning tags |

#### `exa_deep_research`

Comprehensive AI-powered research agent.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| instructions | string | required | Research question/instructions |
| model | enum | exa-research | exa-research (15-45s), exa-research-pro (45s-2min), exa-research-fast |
| showThinking | bool | false | Show reasoning tags |

---

### Linkup Tools

#### `linkup_search`

Factually accurate web search (ranked #1 on OpenAI's SimpleQA benchmark).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| messages | [Message] | required | Conversation messages |
| depth | enum | standard | standard (fast), deep (comprehensive) |

---

## Development

### Project Structure

```
Sources/
├── Core/
│   ├── API/
│   │   ├── Config.swift           # Environment configuration
│   │   ├── PoeAPIClient.swift     # HTTP client
│   │   └── PoeTypes.swift         # Request/response models
│   ├── Helpers/
│   │   ├── ContentStripper.swift  # Strips <think> tags
│   │   └── With.swift             # Functional builder
│   ├── Providers/
│   │   ├── ToolProvider.swift     # Tool factory
│   │   ├── ServerProvider.swift   # MCP server setup
│   │   └── ...                    # Other providers
│   ├── Tools/Search/
│   │   ├── Perplexity/            # 3 tools
│   │   ├── Reka/                  # 3 tools
│   │   ├── Exa/                   # 9 tools
│   │   └── Linkup/                # 1 tool
│   └── Environment.swift          # @TaskLocal DI
└── swift-poe-search-mcp/
    └── swift_search_mcp.swift     # Entry point

Tests/
├── Perplexity/
├── Reka/
├── Exa/
├── Linkup/
└── Environment/                   # Test utilities
```

### Testing

```bash
# Run all tests
POE_API_KEY=your_key swift test

# Run specific provider tests
POE_API_KEY=your_key swift test --filter "PerplexityToolTests"
POE_API_KEY=your_key swift test --filter "ExaToolsTests"

# Run specific tool test
POE_API_KEY=your_key swift test --filter "webSearchTool"
```

**Test Architecture:**
- Framework: Swift Testing (`@Test`, `@Suite`)
- Pattern: `@TaskLocal` environment injection for test isolation
- Type: Integration tests with real API calls

### Adding New Tools

1. Create tool file in appropriate provider directory:

```swift
import Foundation
import MCPToolkit

struct MyNewTool: MCPTool {
  let name = "my_new_tool"
  let description: String? = "Tool description"

  @Schemable
  @ObjectOptions(.additionalProperties { false })
  struct Parameters: Sendable {
    let query: String
    let showThinking: Bool?
  }

  func call(with arguments: Parameters) async throws(ToolError) -> Content {
    let model = "model-name"
    let messages = [PoeMessage(role: "user", content: arguments.query)]

    do {
      let response = try await Environment.current.poeAPIClient().performChatCompletion(
        messages,
        model,
        nil,  // extra_body parameters
        !(arguments.showThinking ?? false)
      )
      return [ToolContentItem(text: response.content)]
    } catch let error as PoeError {
      throw ToolError(error.localizedDescription)
    }
  }
}
```

2. Register in `ToolProvider.swift`:

```swift
if config.isProviderEnabled(.myProvider) {
  tools += [MyNewTool()]
}
```

3. Add test in `Tests/MyProvider/MyProviderToolTests.swift`:

```swift
import Testing
@testable import Core

@Suite(.testEnvironment)
struct MyProviderToolTests {
  @Test func myNewTool() async throws {
    let tool = MyNewTool()
    let result = try await tool.call(with: .init(query: "test"))
    #expect(!result.isEmpty)
  }
}
```

---

## API Reference

### Base Configuration

- **URL**: `https://api.poe.com/v1`
- **Format**: OpenAI-compatible `/v1/chat/completions`
- **Auth**: Bearer token via `Authorization` header
- **Custom params**: Via `extra_body` field

### Message Format

```swift
struct PoeMessage {
  let role: String    // "user", "assistant", "system"
  let content: String
}
```

### Response Format

```swift
struct PoeResponse {
  let content: String
  let citations: [String]?
  let usage: TokenUsage?
}
```

---

## Troubleshooting

- **libcurl error on Linux**: Run `apt-get install libcurl4`
- **Platform not supported**: Only linux-x64 and darwin-arm64 (macOS 14+) are supported
- **Issues**: [GitHub Issues](https://github.com/mehmetbaykar/swift-poe-search-mcp/issues)

---

## License

MIT
