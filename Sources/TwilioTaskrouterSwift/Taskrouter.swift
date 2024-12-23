// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

class Taskrouter {
    var workspaceSid: String
    
    var workerSid: String
    var urlComponents: URLComponents
    var role: String
    var accountSid: String
    var secretSid: String
    
    init(_ token: String) async throws {
        let accessToken = try await AccessToken(token: token)
        guard let taskRouterGrant = accessToken.taskRouterGrant else { throw URLError(.badURL) }
        
        
        self.workspaceSid = taskRouterGrant.workspaceSid
        self.workerSid = taskRouterGrant.workerSid
        self.role = taskRouterGrant.role
        
        var components = URLComponents(string: BASE_PATH)!
        components.path = "/v1/Workspaces/\(self.workspaceSid)"
        self.urlComponents = components
        self.secretSid = accessToken.secret
        self.accountSid = accessToken.accountSid
        
    }
}
