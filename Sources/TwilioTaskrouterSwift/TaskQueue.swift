import Foundation

/// A `TaskQueue` represents a set of `Task`s awaiting assignment.
///
/// This structure is used to manage and organize tasks that need to be assigned
/// and processed. It provides functionality to add, remove, and retrieve tasks
/// from the queue.

struct TaskQueue: Codable {
    var targetWorkers: String
        var workspaceSid: String
        var assignmentActivitySid: String
        var reservationActivityName: String
        var dateUpdated: Date
        var sid: String
        var friendlyName: String
        var accountSid: String
        var taskOrder: String
        var reservationActivitySid: String
        var assignmentActivityName: String
        var dateCreated: Date
        var maxReservedWorkers: Int

        enum CodingKeys: String, CodingKey {
            case targetWorkers = "target_workers"
            case workspaceSid = "workspace_sid"
            case assignmentActivitySid = "assignment_activity_sid"
            case reservationActivityName = "reservation_activity_name"
            case dateUpdated = "date_updated"
            case sid
            case friendlyName = "friendly_name"
            case accountSid = "account_sid"
            case taskOrder = "task_order"
            case reservationActivitySid = "reservation_activity_sid"
            case assignmentActivityName = "assignment_activity_name"
            case dateCreated = "date_created"
            case maxReservedWorkers = "max_reserved_workers"
        }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        self.sid = try container.decode(String.self, forKey: .sid)
        self.accountSid = try container.decode(String.self, forKey: .accountSid)
        self.workspaceSid = try container.decode(String.self, forKey: .workspaceSid)
        self.friendlyName = try container.decode(String.self, forKey: .friendlyName)
        self.assignmentActivityName = try container.decode(String.self, forKey: .assignmentActivityName)
        self.reservationActivityName = try container.decode(String.self, forKey: .reservationActivityName)
        self.assignmentActivitySid = try container.decode(String.self, forKey: .assignmentActivitySid)
        self.reservationActivitySid = try container.decode(String.self, forKey: .reservationActivitySid)
        self.targetWorkers = try container.decode(String.self, forKey: .targetWorkers)
        self.maxReservedWorkers = try container.decode(Int.self, forKey: .maxReservedWorkers)
        self.taskOrder = try container.decode(String.self, forKey: .taskOrder)
        self.dateCreated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateCreated)) ?? .now
        self.dateUpdated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateUpdated)) ?? .now
    }
}
