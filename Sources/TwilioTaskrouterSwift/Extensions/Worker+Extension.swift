import Foundation

// MARK: Public Methods
extension Worker {
    func setActivity(
        _ sid: String,
        rejectPendingReservations: Bool = false
    ) async throws -> Self {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = BASE_PATH
//        components.path = "/v1/Workspaces/\(self.workspaceSid!)/Workers/\(self.workerSid!)"
//        let authHeaderValue = "\(keySid!):\(secretSid!)"
//        var urlRequest = URLRequest(url: components.url!)
//        urlRequest.httpMethod = "POST"
//        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
//        urlRequest.httpBody = try JSONEncoder().encode([
//            "ActivitySid": sid,
//            "RejectPendingReservations": "\(rejectPendingReservations)"
//        ])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    func createTask(
        to: String,
        from: String,
        workflowSid: String,
        taskQueueSid: String,
        options: WorkerTaskOptions? = nil
    ) async throws -> Task {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = BASE_PATH
//        components.path = "/v1/Workspaces/\(self.workspaceSid!)/Tasks"
//        let authHeaderValue = "\(keySid!):\(secretSid!)"
//        var urlRequest = URLRequest(url: components.url!)
//        urlRequest.httpMethod = "POST"
//        urlRequest.allHTTPHeaderFields = [
//            "Authorization": "Basic \(authHeaderValue.toBase64())",
//            "Content-Type": "application/x-www-form-urlencoded"
//        ]
//        
//        var requestParams: [String: String] = [
//            "WorkflowSid": workflowSid,
//            "TaskQueueSid": taskQueueSid,
//            "RoutingTarget": self.sid
//        ]
//        
//        if let options, let virtualStartTime = options.virtualStartTime {
//            let formatter = ISO8601DateFormatter()
//            requestParams["VirtualStartTime"] = formatter.string(from: virtualStartTime)
//        }
//        
//        if let options, let virtualStartTime = options.virtualStartTime {
//            let formatter = ISO8601DateFormatter()
//            requestParams["VirtualStartTime"] = formatter.string(from: virtualStartTime)
//        }
//        
//        var attributes: [String:String] = [
//            "outbound_to": to,
//            "from": from
//        ]
//        
//        if let options, let optionAttributes = options.attributes {
//            attributes.merge(optionAttributes) { (_, new) in new }
//        }
//        
//        let encodedAttributes = try JSONEncoder().encode(attributes)
//        //        let encodedParams = try JSONEncoder().encode(requestParams)
//        
//        requestParams["Attributes"] = String(data: encodedAttributes, encoding: .utf8)
//        
//        print(try JSONEncoder().encode(requestParams))
//        
//        urlRequest.httpBody = try JSONEncoder().encode(requestParams)
//        
//        //        print(String(data: urlRequest.httpBody ?? .init(), encoding: .utf8))
        
        let (data, response) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Task.self, from: data)
    }
    
    func setAttributes(attributes: [String: Any]) throws {
        //        let requestURL = self.getRoutes().getRoute(path: .workerInstance)
        //        try request.post(url: requestURL, params: ["Attributes": attributes])
    }
    
    func updateToken(newToken: String) {
        //        log?.info("Updating token for Worker.")
        //        config?.updateToken(newToken)
        //        signaling?.updateToken(newToken)
    }
    
    private func subscribeToSignalingEvents() {
        //        log?.info("Subscribing to signaling events.")
        //        signaling.onConnected = { [weak self] in
        //            self?.log.info("Connected to signaling.")
        //        }
        //        signaling.onDisconnected = { [weak self] reason in
        //            self?.log.info("Disconnected from signaling. Reason: \(reason)")
        //        }
    }
}

// Structs
extension Worker {
    struct WorkerOptions {
        var connectActivitySid: String?
        var closeExistingSessions: Bool?
        var logLevel: String?
        //        var eventHandlerClass: TaskRouterEventHandler.Type?
    }
    
    struct WorkerTaskOptions {
        var attributes: [String: String]?
        var taskChannelUniqueName: String?
        var taskChannelSid: String?
        var virtualStartTime: Date?
    }
}
