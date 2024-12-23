import Foundation

struct Channel: Codable {
    var accountSid: String
    var assignedTasks: Int
    var available: Bool
    var availableCapacityPercentage: Int
    var capacity: Int
    var lastReservedTime: Date?
    var dateCreated: Date
    var dateUpdated: Date
    var sid: String
    var taskChannelSid: String
    var taskChannelUniqueName: String
    var workerSid: String
    var workspaceSid: String
    
    enum CodingKeys: String, CodingKey {
        case accountSid = "account_sid"
        case assignedTasks = "assigned_tasks"
        case available
        case availableCapacityPercentage = "available_capacity_percentage"
        case capacity = "configured_capacity"
        case lastReservedTime = "last_reserved_time"
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case sid
        case taskChannelSid = "task_channel_sid"
        case taskChannelUniqueName = "task_channel_unique_name"
        case workerSid = "worker_sid"
        case workspaceSid = "workspace_sid"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.accountSid = try container.decode(String.self, forKey: .accountSid)
        self.assignedTasks = try container.decode(Int.self, forKey: .assignedTasks)
        self.available = try container.decode(Bool.self, forKey: .available)
        self.availableCapacityPercentage = try container.decode(Int.self, forKey: .availableCapacityPercentage)
        self.capacity = try container.decode(Int.self, forKey: .capacity)
        self.lastReservedTime = try container.decodeIfPresent(Date.self, forKey: .lastReservedTime)
        self.dateCreated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateCreated)) ?? .now
        self.dateUpdated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateUpdated)) ?? .now
        self.sid = try container.decode(String.self, forKey: .sid)
        self.taskChannelSid = try container.decode(String.self, forKey: .taskChannelSid)
        self.taskChannelUniqueName = try container.decode(String.self, forKey: .taskChannelUniqueName)
        self.workerSid = try container.decode(String.self, forKey: .workerSid)
        self.workspaceSid = try container.decode(String.self, forKey: .workspaceSid)
    }
    
    func onAvailabilityUpdated() async throws {
        // self.capacity = newCapacity
        // WebSocket listener logic
        let webSocketTask = URLSession.shared.webSocketTask(
            with: URL(string: "wss://example.com/socket")!)
        webSocketTask.resume()
        
        do {
            let result = try await webSocketTask.receive()
            switch result {
            case .data(let data):
                print("Received data: \(data)")
            case .string(let text):
                print("Received text: \(text)")
            @unknown default:
                fatalError()
            }
        } catch {
            print("WebSocket error: \(error)")
        }
    }
    
    mutating func omCapacityUpdated(_ completion: @escaping (Channel) -> Void) {
        // self.capacity = newCapacity
        // WebSocket listener logic
        let webSocketTask = URLSession.shared.webSocketTask(
            with: URL(string: "wss://example.com/socket")!)
        webSocketTask.resume()
        
        webSocketTask.receive { result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Received data: \(data)")
                case .string(let text):
                    
                    print("Received text: \(text)")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}
