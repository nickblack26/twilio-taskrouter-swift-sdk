import Foundation

enum Mode: String, Codable {
    case cold, warm
}

struct IncomingTranfer: Codable {
    let dateCreated: Date
    let dateUpdated: Date
    let mode: Mode
    let queueSid: String
    let reservationSid: String
    let to: String
    let transferFailedReason: String?
    let type: String
    let sid: String
    let status: String
    let workerSid: String
    let workflowSid: String
}

struct OutgoingTransfer: Codable {
    let dateCreated: Date
    let dateUpdated: Date
    let mode: Mode
    let queueSid: String
    let reservationSid: String
    let to: String
    let transferFailedReason: String?
    let type: String
    let sid: String
    let status: String
    let workerSid: String
    let workflowSid: String

    func cancel() async throws {
        // Simulate the cancel operation
        let success = Bool.random()
        if success {
            // Notify that the transfer was canceled
            // NotificationCenter.default.post(name: .outgoingTransferCanceled, object: self)
        } else {
            // Notify that the cancel attempt failed
            // NotificationCenter.default.post(name: .outgoingTransferAttemptFailed, object: self)
            // throw TransferError.cancelFailed
        }
    }
}
