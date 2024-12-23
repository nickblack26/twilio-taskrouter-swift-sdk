import Foundation

struct Activity: Codable {
    var accountSid: String
    var available: Bool
    var dateCreated: Date
    var dateUpdated: Date
    var friendlyName: String
    var sid: String
    var workspaceSid: String
    
    enum CodingKeys: String, CodingKey {
        case accountSid = "account_sid"
        case available = "available"
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case friendlyName = "friendly_name"
        case sid = "sid"
        case workspaceSid = "workspace_sid"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.accountSid = try container.decode(String.self, forKey: .accountSid)
        self.available = try container.decode(Bool.self, forKey: .available)
        self.dateCreated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateCreated)) ?? .now
        self.dateUpdated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateUpdated)) ?? .now
        self.friendlyName = try container.decode(String.self, forKey: .friendlyName)
        self.sid = try container.decode(String.self, forKey: .sid)
        self.workspaceSid = try container.decode(String.self, forKey: .workspaceSid)
    }
    
    func setAsCurrent(_ options: ActivityUpdateOptions? = nil) async throws -> Self {
        let url = URL(
            string:
                "https://taskrouter.twilio.com/v1/Workspaces/\(workspaceSid)/Workers/\(accountSid)/Activity"
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(["ActivitySid": sid])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let activity = try JSONDecoder().decode(Activity.self, from: data)
        return activity
    }
}

extension Activity {
    struct ActivityUpdateOptions {
        var rejectPendingReservations: Bool?
    }
}
