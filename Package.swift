// swift-tools-version: 6.0
import PackageDescription
let package = Package(
  name: "mcp-server-kit",
  platforms: [.macOS(.v14)],
  products: [.library(name: "MCPServerKit", targets: ["MCPServerKit"])],
  dependencies: [.package(path: "../atproto-primitives")],
  targets: [
    .target(name: "MCPServerKit", dependencies: [.product(name: "AtprotoPrimitives", package: "atproto-primitives")], path: "Sources/MCPServerKit"),
    .testTarget(name: "MCPServerKitTests", dependencies: ["MCPServerKit"], path: "Tests/MCPServerKitTests"),
  ]
)
