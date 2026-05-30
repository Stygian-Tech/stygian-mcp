// swift-tools-version: 6.0
import PackageDescription
let package = Package(
  name: "mcp-server-kit",
  platforms: [.macOS(.v13)],
  products: [.library(name: "MCPServerKit", targets: ["MCPServerKit"])],
  dependencies: [],
  targets: [
    .target(name: "MCPServerKit", dependencies: [], path: "Sources/MCPServerKit"),
    .testTarget(name: "MCPServerKitTests", dependencies: ["MCPServerKit"], path: "Tests/MCPServerKitTests"),
  ]
)
