// swift-tools-version: 6.0
import PackageDescription
let package = Package(
  name: "stygian-mcp",
  platforms: [.macOS(.v14)],
  products: [.library(name: "StygianMCP", targets: ["StygianMCP"])],
  dependencies: [.package(path: "../stygian-core")],
  targets: [
    .target(name: "StygianMCP", dependencies: [.product(name: "StygianCore", package: "stygian-core")], path: "Sources/StygianMCP"),
    .testTarget(name: "StygianMCPTests", dependencies: ["StygianMCP"], path: "Tests/StygianMCPTests"),
  ]
)
