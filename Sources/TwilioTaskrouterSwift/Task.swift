import AnyCodable
import Foundation

struct Task: Codable {
    var addOns: [String: AnyCodable]?
    var age: Int?
    var attributes: [String: AnyCodable]
    var dateCreated: Date
    var dateUpdated: Date
    var priority: Int
    var queueName: String
    var queueSid: String
    var reason: String
    var routingTarget: String
    var sid: String
    var status: Status
    var taskChannelSid: String
    var taskChannelUniqueName: String
    var timeout: Int
    var transfers: Transfers
    var version: String
    var reservationSid: String
    var virtualStartTime: Date?
    var workflowName: String
    var workflowSid: String
    
    
    enum CodingKeys: String, CodingKey {
        case addOns = "add_ons"
        case age
        case attributes
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case priority
        case queueName = "queue_name"
        case queueSid = "queue_sid"
        case reason
        case routingTarget = "routing_target"
        case sid
        case status
        case taskChannelSid = "task_channel_sid"
        case taskChannelUniqueName = "task_channel_unique_name"
        case timeout
        case transfers
        case version
        case reservationSid = "reservation_sid"
        case virtualStartTime = "virtual_start_time"
        case workflowName = "workflow_name"
        case workflowSid = "workflow_sid"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.addOns = try container.decodeIfPresent([String : AnyCodable].self, forKey: .addOns)
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)
        let stringifiedAttributes = try container.decode(String.self, forKey: .attributes)
        self.attributes = [:]
        if let data = stringifiedAttributes.data(using: .utf8) {
            do {
                self.attributes = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyCodable] ?? [:]
            } catch {
                self.attributes = [:]
            }
        }
        self.dateCreated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateCreated)) ?? .now
        self.dateUpdated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateUpdated)) ?? .now
        self.priority = try container.decode(Int.self, forKey: .priority)
        self.queueName = try container.decode(String.self, forKey: .queueName)
        self.queueSid = try container.decode(String.self, forKey: .queueSid)
        self.reason = try container.decode(String.self, forKey: .reason)
        self.routingTarget = try container.decode(String.self, forKey: .routingTarget)
        self.sid = try container.decode(String.self, forKey: .sid)
        self.status = try container.decode(Task.Status.self, forKey: .status)
        self.taskChannelSid = try container.decode(String.self, forKey: .taskChannelSid)
        self.taskChannelUniqueName = try container.decode(String.self, forKey: .taskChannelUniqueName)
        self.timeout = try container.decode(Int.self, forKey: .timeout)
        self.transfers = try container.decode(Transfers.self, forKey: .transfers)
        self.version = try container.decode(String.self, forKey: .version)
        self.reservationSid = try container.decode(String.self, forKey: .reservationSid)
        self.virtualStartTime = virtualStartTime != nil ? dateFormatter.date(from: try container.decodeIfPresent(String.self, forKey: .virtualStartTime)!) : nil
        self.workflowName = try container.decode(String.self, forKey: .workflowName)
        self.workflowSid = try container.decode(String.self, forKey: .workflowSid)
    }
    
    enum Status: String, Codable {
        case pending
        case reserved
        case assigned
        case canceled
        case compvared
        case wrapping
    }
    
    mutating func compvare(reason: String) async throws {
        // Implementation to update the Task status to 'compvared'
        self.status = .compvared
        self.reason = reason
    }
    
    func fetchLatestVersion() async throws -> Task {
        // Implementation to fetch the latest version of this Task
        // This is a placeholder implementation
        return self
    }
    
    mutating func hold(targetWorkerSid: String, onHold: Bool, options: TaskHoldOptions) async throws
    {
        // Implementation to hold/unhold the worker's call leg in the Conference
        // This is a placeholder implementation
    }
    
    mutating func kick(workerSid: String) async throws {
        // Implementation to kick another active Worker participant from the ongoing conference
        // This is a placeholder implementation
    }
    
    mutating func setAttributes(attributes: [String: AnyCodable]) async throws {
        // Implementation to update the Task attributes to the given attributes
        self.attributes = attributes
    }
    
    mutating func setVirtualStartTime(date: Date) async throws {
        // Implementation to set virtual start time of the Task
        self.virtualStartTime = date
    }
    
    mutating func transfer(to: String, options: TransferOptions? = nil) async throws {
        // Implementation to transfer the Task to another entity
        // This is a placeholder implementation
    }
    
    mutating func updateParticipant(options: TaskParticipantOptions) async throws {
        // Implementation to update the Customer leg in the Conference
        // This is a placeholder implementation
    }
    
    mutating func wrapUp(options: WrappingOptions) async throws {
        // Implementation to update the Task status to 'wrapping'
        self.status = .wrapping
    }
}

extension Task {
    struct TaskHoldOptions {
        var holdUrl: String?
        var holdMethod: String?
    }
    
    struct TransferOptions {
        var attributes: [String: AnyCodable]?
        var mode: Mode = .warm
        var priority: Int?
    }
    
    struct TaskParticipantOptions {
        var hold: Bool?
        var holdUrl: String?
        var holdMethod: String
    }
    struct WrappingOptions {
        var reason: String?
    }
}
