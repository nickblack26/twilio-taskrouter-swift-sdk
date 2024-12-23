import Foundation

final class Workspace {
    private var request: URLRequest
    
    // MARK: Config
    var accountSid: String?
    var keySid: String?
    var role: String?
    var secretSid: String?
    var urlComponents: URLComponents?
    var workerSid: String?
    
    var workspaceSid: String
    
    init(
        jwt: String,
        options: WorkspaceOptions = WorkspaceOptions(),
        workspaceSid: String? = nil
    ) async throws {
        let payload = try await AccessToken(token: jwt)
        self.accountSid = payload.accountSid
        self.role = payload.taskRouterGrant?.role ?? "worker"
        self.keySid = payload.keySid
        self.secretSid = payload.secret
        self.workerSid = payload.taskRouterGrant?.workerSid ?? ""
        self.workspaceSid = payload.taskRouterGrant?.workspaceSid ?? ""
        
        // MARK: Build Url Component
        var components = URLComponents()
        components.scheme = "https"
        components.host = BASE_PATH
        components.path = "/v1/Workspaces/\(self.workspaceSid)"
        self.urlComponents = components
        
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        self.request = urlRequest
    }
    
    func fetchWorker(workerSid: String) async throws -> Worker {
        guard var localComponents = self.urlComponents else { throw URLError(.unknown) }
        localComponents.path.append("/workers")
        
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        print(authHeaderValue)
        
        var urlRequest = URLRequest(url: localComponents.url!)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(Worker.self, from: data)
    }
    
    func fetchWorkers(with params: FetchWorkersParams? = nil) async throws -> [String: Worker] {
        guard var localComponents = self.urlComponents else { throw URLError(.unknown) }
        localComponents.path.append("/Workers")
       
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        print(authHeaderValue)
        
        var urlRequest = URLRequest(url: localComponents.url!)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let workerResponse = try JSONDecoder().decode(WorkerResponse.self, from: data)
        
        return workerResponse.workers.reduce(into: [:]) { result, worker in
            result[worker.sid] = worker
        }
    }
    
    func fetchTaskQueue(queueSid: String) async throws -> TaskQueue {
        guard var localComponents = self.urlComponents else { throw URLError(.unknown) }
        localComponents.path.append("/TaskQueues/\(queueSid)")
        
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        print(authHeaderValue)
        
        var urlRequest = URLRequest(url: localComponents.url!)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(TaskQueue.self, from: data)
    }
    
    func fetchTaskQueues() async throws -> [String: TaskQueue] {
        guard var localComponents = self.urlComponents else { throw URLError(.unknown) }
        localComponents.path.append("/TaskQueues")
        
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        print(authHeaderValue)
        
        var urlRequest = URLRequest(url: localComponents.url!)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let taskQueueResponse = try JSONDecoder().decode(TaskQueueResponse.self, from: data)
        
        return taskQueueResponse.taskQueues.reduce(into: [:]) { result, worker in
            result[worker.sid] = worker
        }
    }
    
    func updateToken(newToken: String) throws {
    }
}

extension Workspace {
    struct WorkspaceOptions {
        var region: String?
        var pageSize: Int?
        let logLevel: LogLevel? = .error
    }
    
    struct FetchWorkersParams {
        var AfterSid: String?
        var FriendlyName: String?
        var ActivitySid: String?
        var ActivityName: String?
        var TargetWorkersExpression: String?
        var Ordering: DateStatusChangedOrdering?
        var MaxWorkers: Int?
        
        enum DateStatusChangedOrdering: String {
            case asc, desc
            
            var path: String {
                switch self {
                case .asc:
                    "DateStatusChangedOrdering:asc"
                case .desc:
                    "DateStatusChangedOrdering:desc"
                }
            }
        }
    }
    
    struct FetchTaskQueuesParams {
        var AfterSid: String?
        var FriendlyName: String?
        var Ordering: DateUpdatedOrdering?
        var WorkerSid: String?
        
        enum DateUpdatedOrdering: String {
            case asc, desc
            
            var path: String {
                switch self {
                case .asc:
                    "DateStatusChangedOrdering:asc"
                case .desc:
                    "DateStatusChangedOrdering:desc"
                }
            }
        }
    }
}

extension Workspace {
    struct TaskQueueResponse: Decodable {
        var taskQueues: [TaskQueue]
        
        enum CodingKeys: String, CodingKey {
            case taskQueues = "task_queues"
        }
    }
    
    struct WorkerResponse: Decodable {
        var workers: [Worker]
    }
}

// Example error enum
enum WorkspaceError: Error {
    case invalidToken(String)
}
