import AnyCodable
import Foundation
import Starscream
import FlexEmit

class Worker: Listenable, Codable {
    typealias Event = WORKER_EVENTS
    
    // MARK: Internal Properties
    private var closeExistingSessions: Bool?
    private var logLevel: String?
    private var config: Configuration?
    private var request: URLRequest?
    
    // MARK: Config Members
    private var accountSid: String?
    private var keySid: String?
    private var role: String?
    private var secretSid: String?
    private var urlComponents: URLComponents?
    private var workerSid: String?
    private var workspaceSid: String?
    
    // MARK: Public Members
    var activities: [String: Activity]? = [:]
    var activity: Activity?
    var activitySid: String
    var activityName: String?
    var attributes: [String: AnyCodable] = [:]
    var available: Bool
    var channels: [String: Channel]? = [:]
    var connectActivitySid: String?
    var dateCreated: Date
    var dateStatusChanged: Date
    var dateUpdated: Date?
    var name: String {
        get {
            self.friendlyName
        }
    }
    var reservations: [String: Reservation]? = [:]
    var sid: String
    var workerActivitySid: String
    var dateActivityChanged: Date?
    var friendlyName: String
    
    // MARK: Worker Initalization With JWT
    init(
        token: String,
        options: WorkerOptions? = nil
    ) async throws {
        // MARK: Decode JWT
        let payload = try await AccessToken(token: token)
        self.accountSid = payload.accountSid
        self.role = payload.taskRouterGrant?.role ?? ""
        self.keySid = payload.keySid
        self.secretSid = payload.secret
        self.workerSid = payload.taskRouterGrant?.workerSid ?? ""
        self.workspaceSid = payload.taskRouterGrant?.workspaceSid ?? ""
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = BASE_PATH
        components.path = "/v1/Workspaces/\(self.workspaceSid!)/Workers/\(self.workerSid!)"
        self.urlComponents = components
        
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        print(authHeaderValue)
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        self.request = urlRequest
        
        print(urlRequest.allHTTPHeaderFields)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let worker = try JSONDecoder().decode(Self.self, from: data)
        
        self.activities = worker.activities
        self.activity = worker.activity
        self.activitySid = worker.activitySid
        self.activityName = worker.activityName
        self.attributes = worker.attributes
        self.available = worker.available
        self.channels = worker.channels
        self.connectActivitySid = worker.connectActivitySid
        self.dateCreated = worker.dateCreated
        self.dateStatusChanged = worker.dateStatusChanged
        self.dateUpdated = worker.dateUpdated
        self.reservations = worker.reservations
        self.sid = worker.sid
        self.workerActivitySid = worker.workerActivitySid
        self.dateActivityChanged = worker.dateActivityChanged
        self.friendlyName = worker.friendlyName
        
//        self.channels = try await getChannels()
//        self.reservations = try await getReservations()
//        self.activity = try await getActivity()
    }
    
    // MARK: Worker Decoder
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accountSid = try container.decodeIfPresent(String.self, forKey: .accountSid)
        self.keySid = try container.decodeIfPresent(String.self, forKey: .keySid)
        self.role = try container.decodeIfPresent(String.self, forKey: .role)
        self.secretSid = try container.decodeIfPresent(String.self, forKey: .secretSid)
        self.urlComponents = try container.decodeIfPresent(URLComponents.self, forKey: .urlComponents)
        self.workerSid = try container.decodeIfPresent(String.self, forKey: .workerSid)
        self.workspaceSid = try container.decodeIfPresent(String.self, forKey: .workspaceSid)
        self.activities = try container.decodeIfPresent([String : Activity].self, forKey: .activities)
        self.activity = try container.decodeIfPresent(Activity.self, forKey: .activity)
        self.activitySid = try container.decode(String.self, forKey: .activitySid)
        self.activityName = try container.decodeIfPresent(String.self, forKey: .activityName)
        let stringifiedAttributes = try container.decode(String.self, forKey: .attributes)
        if let data = stringifiedAttributes.data(using: .utf8) {
            do {
                self.attributes = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyCodable] ?? [:]
            } catch {
                self.attributes = [:]
            }
        }
        self.available = try container.decode(Bool.self, forKey: .available)
        self.channels = try container.decodeIfPresent([String : Channel].self, forKey: .channels)
        self.connectActivitySid = try container.decodeIfPresent(String.self, forKey: .connectActivitySid)
        self.reservations = try container.decodeIfPresent([String : Reservation].self, forKey: .reservations)
        self.sid = try container.decode(String.self, forKey: .sid)
        self.friendlyName = try container.decode(String.self, forKey: .friendlyName)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        self.dateCreated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateCreated)) ?? .now
        self.dateStatusChanged = dateFormatter.date(from: try container.decode(String.self, forKey: .dateStatusChanged)) ?? .now
        self.dateUpdated = dateFormatter.date(from: try container.decode(String.self, forKey: .dateUpdated)) ?? .now
        self.workerActivitySid = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case accountSid = "account_sid"
        case keySid = "key_sid"
        case role
        case secretSid = "secret_sid"
        case urlComponents = "url_components"
        case workerSid
        case workspaceSid = "workspace_sid"
        
        case activities
        case activity
        case activitySid = "activity_sid"
        case activityName = "activity_name"
        case attributes
        case available
        case channels
        case connectActivitySid = "connect_activity_sid"
        case dateCreated = "date_created"
        case dateStatusChanged = "date_status_changed"
        case dateUpdated = "date_updated"
        case reservations
        case sid
        case friendlyName = "friendly_name"
    }
}

// MARK: Private Methods
extension Worker {
    private func getChannels () async throws -> [String: Channel] {
        guard var localComponents = self.urlComponents else { throw URLError(.unknown) }
        localComponents.path.append("/Workers/\(self.workerSid!)/Channels")

        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        var urlRequest = URLRequest(url: localComponents.url!)
        
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print(response)
            throw URLError(.badServerResponse)
        }
        let channels = try JSONDecoder().decode(WorkerChannelResponse.self, from: data)
        
        return channels.channels.reduce(into: [:]) { channels, channel in
            channels[channel.sid] = channel
        }
    }
    
    private func getReservations () async throws -> [String: Reservation] {
        guard var localComponents = self.urlComponents else { throw URLError(.unknown) }
        localComponents.path.append("/Workers/\(self.workerSid!)/Reservations")
        
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        
        var urlRequest = URLRequest(url: localComponents.url!)
        
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print(response)
            throw URLError(.badServerResponse)
        }
        let reservationResponse = try JSONDecoder().decode(WorkerReservationResponse.self, from: data)
        
        return reservationResponse.reservations.reduce(into: [:]) { reservations, reservation in
            reservations[reservation.sid] = reservation
        }
    }
    
    private func getActivity () async throws -> Activity {
        guard var localComponents = self.urlComponents else { throw URLError(.unknown) }
        localComponents.path.append("/Activities/\(self.activitySid)")
       
        let authHeaderValue = "\(keySid!):\(secretSid!)"
        var urlRequest = URLRequest(url: localComponents.url!)
        urlRequest.allHTTPHeaderFields = ["Authorization": "Basic \(authHeaderValue.toBase64())"]
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print(response)
            throw URLError(.badServerResponse)
        }
        let activity = try JSONDecoder().decode(Activity.self, from: data)
        
        return activity
    }
    
    struct WorkerChannelResponse: Codable {
        let channels: [Channel]
    }
    
    struct WorkerReservationResponse: Codable {
        let reservations: [Reservation]
    }
}
