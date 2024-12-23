import Foundation

struct Transfers: Codable {
    var incoming: [IncomingTranfer]
    var outgoing: [OutgoingTransfer]
}
