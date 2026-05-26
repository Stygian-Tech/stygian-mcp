// swift-tools-version: 6.0
import PackageDescription
let package = Package(
  name: "mcp-server-kit",
  platforms: [.macOS(.v14)],
  products: [.library(name: "MCPServerKit", targets: ["MCPServerKit"])],
  dependencies: [.package(path: "../atproto-primitive-kit")],
  targets: [
    .target(name: "MCPServerKit", dependencies: [.product(name: "ATProtoPrimitiveKit", package: "atproto-primitive-kit")], path: "Sources/MCPServerKit"),
    .testTarget(name: "MCPServerKitTests", dependencies: ["MCPServerKit"], path: "Tests/MCPServerKitTests"),
  ]
)
