import AnyCodable
import Foundation

struct WorkerDescriptor: Codable {
    let accountSid: String
    let activityName: String
    let activitySid: String
    let attributes: [String: AnyCodable]
    let available: Bool
    let dateCreated: Date
    let dateStatusChanged: Date
    let dateUpdated: Date
    let name: String
    let sid: String
    let workspaceSid: String
    let version: String
    // Duplicated fields for sync compatibility
    let workerSid: String
    let workerActivitySid: String
    let dateActivityChanged: Date
    let friendlyName: String

    init(
        accountSid: String,
        activityName: String,
        activitySid: String,
        attributes: [String: AnyCodable],
        available: Bool,
        dateCreated: Date,
        dateStatusChanged: Date,
        dateUpdated: Date,
        name: String,
        sid: String,
        workspaceSid: String,
        version: String,
        workerSid: String,
        workerActivitySid: String,
        dateActivityChanged: Date,
        friendlyName: String
    ) {
        self.accountSid = accountSid
        self.activityName = activityName
        self.activitySid = activitySid
        self.attributes = attributes
        self.available = available
        self.dateCreated = dateCreated
        self.dateStatusChanged = dateStatusChanged
        self.dateUpdated = dateUpdated
        self.name = name
        self.sid = sid
        self.workspaceSid = workspaceSid
        self.version = version
        self.workerSid = workerSid
        self.workerActivitySid = workerActivitySid
        self.dateActivityChanged = dateActivityChanged
        self.friendlyName = friendlyName
    }

    //    init(from decoder: any Decoder) throws {
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //        self.accountSid = try container.decode(String.self, forKey: .accountSid)
    //        self.activityName = try container.decode(String.self, forKey: .activityName)
    //        self.activitySid = try container.decode(String.self, forKey: .activitySid)
    //        self.attributes = try container.decode([String : String].self, forKey: .attributes)
    //        self.available = try container.decode(Bool.self, forKey: .available)
    //        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    //        self.dateStatusChanged = try container.decode(Date.self, forKey: .dateStatusChanged)
    //        self.dateUpdated = try container.decode(Date.self, forKey: .dateUpdated)
    //        self.name = try container.decode(String.self, forKey: .name)
    //        self.sid = try container.decode(String.self, forKey: .sid)
    //        self.workspaceSid = try container.decode(String.self, forKey: .workspaceSid)
    //        self.version = try container.decode(String.self, forKey: .version)
    //        self.workerSid = try container.decode(String.self, forKey: .workerSid)
    //        self.workerActivitySid = try container.decode(String.self, forKey: .workerActivitySid)
    //        self.dateActivityChanged = try container.decode(Date.self, forKey: .dateActivityChanged)
    //        self.friendlyName = try container.decode(String.self, forKey: .friendlyName)
    //    }
}

// Required properties to validate descriptor
let WorkerProperties: [String] = [
    "account_sid", "activity_name", "activity_sid", "attributes", "available",
    "date_created", "date_status_changed", "date_updated", "friendly_name",
    "sid", "workspace_sid", "version",
]
