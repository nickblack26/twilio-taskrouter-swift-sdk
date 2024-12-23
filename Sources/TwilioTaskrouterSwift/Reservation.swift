import Foundation

struct Reservation: Codable {
    var accountSid: String
    var dateCreated: Date
    var dateUpdated: Date
    var reservationStatus: ReservationStatus
    var sid: String
    var taskSid: String
    var workerName: String
    var workerSid: String
    var workspaceSid: String
    
    enum CodingKeys: String, CodingKey {
        case accountSid = "account_sid"
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case reservationStatus = "reservation_status"
        case sid
        case taskSid = "task_sid"
        case workerName = "worker_name"
        case workerSid = "worker_sid"
        case workspaceSid = "workspace_sid"
    }
    
    // Event listener functions
    func onAccepted() {
        // Handle accepted event
    }
    
    func onCanceled() {
        // Handle canceled event
    }
    
    func onCompleted() {
        // Handle completed event
    }
    
    func onRejected() {
        // Handle rejected event
    }
    
    func onRescinded() {
        // Handle rescinded event
    }
    
    func onTimeout() {
        // Handle timeout event
    }
    
    func onWrapup() {
        // Handle wrapup event
    }
    
    enum ReservationStatus: String, Codable {
        case pending, accepted, rejected, timeout, canceled, rescinded
    }
}
