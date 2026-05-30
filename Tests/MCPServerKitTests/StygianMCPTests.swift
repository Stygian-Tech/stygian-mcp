import Foundation
import MCPServerKit
import Testing

@Suite struct StygianMCPTests {
  @Test func decodesJSONRPCIdsAndParams() throws {
    let payload = Data(#"{"jsonrpc":"2.0","id":"abc","method":"tools/call","params":{"name":"summarize","arguments":{"count":3,"enabled":true,"detail":"short"}}}"#.utf8)

    let request = try JSONDecoder().decode(MCPRequest.self, from: payload)

    #expect(request.id == .string("abc"))
    #expect(request.method == .toolsCall)
    #expect(request.params?.name == "summarize")
    #expect(request.params?.arguments == ["count": "3", "enabled": "true", "detail": "short"])
  }

  @Test func encodesInitializeResultWithCapabilities() throws {
    let result = MCPInitializeResult(
      protocolVersion: MCPProtocolVersion.negotiated(requested: "2024-11-05"),
      capabilities: MCPServerCapabilities(
        tools: .init(listChanged: true),
        resources: .init(subscribe: true, listChanged: true),
        prompts: .init(listChanged: true)
      ),
      serverInfo: .init(
        name: "MyContextProtocol",
        version: "test",
        title: "MyContextProtocol",
        description: "Hosted MCP gateway",
        websiteUrl: "https://example.com"
      ),
      instructions: "Call the catalog first."
    )

    let data = try JSONEncoder().encode(result)
    let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

    #expect(object["protocolVersion"] as? String == MCPProtocolVersion.v2024_11_05.rawValue)
    #expect((object["serverInfo"] as? [String: Any])?["name"] as? String == "MyContextProtocol")
    #expect(object["instructions"] as? String == "Call the catalog first.")
  }

  @Test func buildsStableCapabilitySchemas() throws {
    let toolSchema = MCPToolSchemaBuilder.toolInputSchemaJson(
      description: String(repeating: "a", count: 520),
      summary: nil
    )
    let toolObject = try #require(JSONSerialization.jsonObject(with: Data(toolSchema.utf8)) as? [String: Any])
    let properties = try #require(toolObject["properties"] as? [String: Any])
    let detail = try #require(properties["detail"] as? [String: Any])

    #expect(toolObject["type"] as? String == "object")
    #expect(toolObject["additionalProperties"] as? Bool == false)
    #expect((detail["description"] as? String)?.contains("...") == true)

    let resourceJson = MCPToolSchemaBuilder.resourceMetaJson(
      skillName: "Skill Name",
      useWhen: ["when useful"],
      avoidWhen: nil,
      failureModes: ["fallback"],
      invokeFirst: true
    )
    let meta = try #require(MCPToolSchemaBuilder.parseResourceMeta(resourceJson))

    #expect(meta.uri == "ctx://skill/Skill%20Name")
    #expect(meta.mimeType == "text/markdown")
    #expect(meta.useWhen == ["when useful"])
    #expect(meta.failureModes == ["fallback"])
    #expect(meta.invokeFirst == true)
  }

  @Test func dispatchesRegisteredMethodsAndMissingHandlers() async throws {
    let dispatcher = MCPDispatcher<String>()
      .register(.initialize) { request, context in
        #expect(request.method == .initialize)
        return "initialized \(context)"
      }

    let request = MCPRequest(jsonrpc: "2.0", id: .int(1), method: .initialize, params: nil)

    let result = try await dispatcher.dispatch(request, context: "project")
    #expect(result == "initialized project")
    await #expect(throws: MCPDispatchError.methodNotFound("tools/list")) {
      try await dispatcher.dispatch(
        MCPRequest(jsonrpc: "2.0", id: nil, method: .toolsList, params: nil),
        context: "project"
      )
    }
  }
}
