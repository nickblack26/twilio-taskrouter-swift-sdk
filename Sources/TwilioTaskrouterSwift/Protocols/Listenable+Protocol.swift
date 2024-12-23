import Foundation
import Starscream
import AnyCodable

protocol Listenable {
    associatedtype T: Codable = Self
    associatedtype Event: RawRepresentable where Event.RawValue: StringProtocol
    
    var request: URLRequest { get }
    var socket: WebSocket { get }
    
    func on(event: Event, _ completion: @escaping (_ data: T) -> Void)
}

extension Listenable {    
    var request: URLRequest {
        get {
            var components = URLComponents()
            components.host = "event-bridge.twilio.com"
            components.path = "/v1/wschannels"
            components.scheme = "wss"
            
            components.queryItems = [
                URLQueryItem(name: "token", value: ""),
                URLQueryItem(name: "closeExistingSessions", value: "false"),
                URLQueryItem(name: "clientVersion", value: "2.0.11"),
            ]
            
            guard let url = components.url else { fatalError() }
            
            var request = URLRequest(url: url)
            request.timeoutInterval = 5
            return request
        }
    }
    
    var socket: WebSocket {
        get {
            let websocket = WebSocket(request: self.request)
            websocket.connect()
            return websocket
        }
    }
    
    func on(event: Event, _ completion: @escaping (_ data: T) -> Void) {
        print("running")
        var isConnected: Bool = false
        
        socket.onEvent = { socketEvent in
            switch socketEvent {
                // handle events just like above...
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                print("received text", string)
                guard string.contains(event.rawValue) else { return }
                guard let data = try? JSONDecoder().decode(WebsocketResponse.self, from: string.data(using: .utf8)!) else { return }
                print(data)
                completion(data as! T)
                print("Received text: \(string)")
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                print(error)
                //                   handleError(error)
            case .peerClosed:
                break
            }
        }
    }
}


struct WebsocketResponse: Codable {
    let eventType: String
    let payload: [String:AnyCodable]
    
    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
        case payload
    }
}
