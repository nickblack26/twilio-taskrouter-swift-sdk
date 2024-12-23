import Foundation

struct Configuration: Decodable {
    private var EB_SERVER: String?
    private var WS_SERVER: String?
    private var _log: String?
    private var _logLevel: String?
    
    internal var logIdentifier: String?
    internal var enableVersionCheck: Bool?
    
    var token: String
    var workerSid: String
    var workspaceSid: String
    
    init(
        _ token: String,
        _ options: Configuration.Options = .init()
    ) {
        self.logIdentifier = options.logIdentifier
        self._logLevel = options.logLevel
        self._log = ""
        self.token = token
        self.EB_SERVER = options.ebServer
        self.WS_SERVER = options.wsServer
        self.enableVersionCheck = options.enableVersionCheck
        
        guard let ebServer = options.ebServer, let wsServer = options.wsServer else {
            fatalError(
                "'ebServer' and 'wsServer' parameter will be removed in next major version. "
                + "You may start using 'region' and 'edge'.")
        }
        
        var edgeAndRegionSlice = ""
        
        if let region = options.region, region != "us1" {
            edgeAndRegionSlice.append(".\(region)")
        }
        
        self.EB_SERVER = "https://event-bridge\(edgeAndRegionSlice).twilio.com/v1/wschannels"
        self.WS_SERVER = "wss://event-bridge\(edgeAndRegionSlice).twilio.com/v1/wschannels"
        
        self.workerSid = ""
        self.workspaceSid = ""
    }
    
    /**
     * Update the token
     * @public
     * @param {string} newToken - The new token to be used
     */
    mutating func updateToken(newToken: String) {
        self.token = newToken
    }
    
    /**
     * @public
     * @return {string}
     */
    mutating func getLogIdentifier() -> String? {
        return self.logIdentifier
    }
    
    struct Options {
        var logIdentifier: String?
        var logLevel: String?
        var ebServer: String?
        var wsServer: String?
        var enableVersionCheck: Bool?
        var region: String?
    }
}
