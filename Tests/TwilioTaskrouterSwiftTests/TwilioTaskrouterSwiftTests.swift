import Foundation
import Testing
import Starscream
@testable import TwilioTaskrouterSwift

@Test func createWorker() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let accessToken = try AccessToken(
        accountSid: ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"] ?? "",
        keySid: ProcessInfo.processInfo.environment["TWILIO_API_KEY_SID"] ?? "",
        secret: ProcessInfo.processInfo.environment["TWILIO_API_KEY_SECRET"] ?? "",
        taskRouterGrant: .init(
            workspaceSid: ProcessInfo.processInfo.environment["TWILIO_WORKSPACE_SID"] ?? "",
            workerSid: "",
            role: "supervisor"
        ),
        options: .init(
            identity: ""
        )
    )
    
    let worker = try await Worker(token: accessToken.toJwt())
    
    worker.on(event: .ready) { data in
        print(data)
    }
    
    #expect(worker.sid == "")
    
    try await worker.createTask(
        to: "+",
        from: "+",
        workflowSid: "",
        taskQueueSid: ""
    )
    
    #expect(worker.channels?.count ?? 0 > 0)
    #expect(worker.activity?.friendlyName.count ?? 0 > 0)
}

@Test func createSupervisor() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let accessToken = try AccessToken(
        accountSid: ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"] ?? "",
        keySid: ProcessInfo.processInfo.environment["TWILIO_API_KEY_SID"] ?? "",
        secret: ProcessInfo.processInfo.environment["TWILIO_API_KEY_SECRET"] ?? "",
        taskRouterGrant: .init(
            workspaceSid: ProcessInfo.processInfo.environment["TWILIO_WORKSPACE_SID"] ?? "",
            workerSid: "",
            role: "supervisor"
        ),
        options: .init(
            identity: ""
        )
    )
    
    
    let supervisor = try await Supervisor(accessToken.toJwt())
    
    #expect(supervisor.sid == "")
}

@Test func createWorkspace() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let accessToken = try AccessToken(
        accountSid: ProcessInfo.processInfo.environment["TWILIO_ACCOUNT_SID"] ?? "",
        keySid: ProcessInfo.processInfo.environment["TWILIO_API_KEY_SID"] ?? "",
        secret: ProcessInfo.processInfo.environment["TWILIO_API_KEY_SECRET"] ?? "",
        taskRouterGrant: .init(
            workspaceSid: ProcessInfo.processInfo.environment["TWILIO_WORKSPACE_SID"] ?? "",
            workerSid: "",
            role: "supervisor"
        ),
        options: .init(
            identity: ""
        )
    )
    
    let workspace = try await Workspace(jwt: accessToken.toJwt())
    
    #expect(workspace.workspaceSid == "")
    
    let taskQueues = try await workspace.fetchTaskQueues()
    
    #expect(!taskQueues.isEmpty)
    
    let workers = try await workspace.fetchWorkers()
    
    #expect(!workers.isEmpty)
    
    #expect(workspace.workspaceSid == "")
}

@Test func testEventListeners() async throws {
    var components = URLComponents()
    components.host = "event-bridge.twilio.com"
    components.path = "/v1/wschannels"
    components.scheme = "wss"
    
    components.queryItems = [
        URLQueryItem(name: "token", value: ""),
        URLQueryItem(name: "closeExistingSessions", value: "false"),
        URLQueryItem(name: "clientVersion", value: "2.0.11"),
    ]
    
    guard let url = components.url else { fatalError() }
    let request = URLRequest(url: url)
    let websocket = WebSocket(request: request)
    websocket.connect()
    
    let urlSession = URLSession.shared
    let webSocketTask = urlSession.webSocketTask(with: url)
    
    webSocketTask.resume()
    
    webSocketTask.receive { result in
        switch result {
        case .failure(let error):
            print("Failed to receive message: \(error)")
        case .success(let message):
            switch message {
            case .string(let text):
                print("Received text message: \(text)")
            case .data(let data):
                print("Received binary message: \(data)")
            @unknown default:
                fatalError()
            }
        }
    }
}

