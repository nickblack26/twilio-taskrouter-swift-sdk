import Foundation
import JWTKit

let keys = JWTKeyCollection()

struct AccessToken: JWTPayload {
    private var exp: ExpirationClaim

    func verify(using key: some JWTAlgorithm) throws {
        try self.exp.verifyNotExpired()
    }

    var accountSid: String
    var keySid: String
    var secret: String
    var ttl: Int
    var identity: String
    var nbf: Int?
    var region: String?
//    var grants: [any Grant] = []
    var taskRouterGrant: TaskRouterGrant?

    init(
        accountSid: String,
        keySid: String,
        secret: String,
        taskRouterGrant: TaskRouterGrant,
        options: AccessTokenOptions
    ) throws {
        guard !accountSid.isEmpty else { throw AccessTokenError.invalidAccountSid }
        guard !keySid.isEmpty else { throw AccessTokenError.invalidKeySid }
        guard !secret.isEmpty else { throw AccessTokenError.invalidSecret }
        guard !options.identity.isEmpty else { throw AccessTokenError.invalidIdentity }

        self.accountSid = accountSid
        self.keySid = keySid
        self.secret = secret
        self.ttl = options.ttl ?? 3600
        self.identity = options.identity
        self.taskRouterGrant = taskRouterGrant
        self.nbf = options.nbf
        self.region = options.region
        self.exp = .init(value: Date().addingTimeInterval(TimeInterval(ttl)))
    }

    init(token: String) async throws {
        let payload = try await keys.verify(token, as: Self.self)

        self.accountSid = payload.accountSid
        self.keySid = payload.keySid
        self.secret = payload.secret
        self.ttl = payload.ttl
        self.identity = payload.identity
        self.nbf = payload.nbf
        self.region = payload.region
        self.exp = payload.exp
        self.taskRouterGrant = payload.taskRouterGrant
    }

    mutating func addGrant(_ grant: Grant) {
//        self.grants.append(grant)
    }

    func toJwt() async throws -> String {
        await keys.add(hmac: "secret", digestAlgorithm: .sha512, kid: "my-key")
        // let jwt =
        // guard AccessToken.algorithms.contains(algorithm) else {
        //     throw AccessTokenError.unsupportedAlgorithm
        // }

        // let now = Int(Date().timeIntervalSince1970)
        // //        var payload = Payload(jti: "\(keySid)-\(now)", grants: ["identity": identity])

        // // for grant in grants {
        // //     //            payload.grants[grant.key] = grant.toPayload()
        // // }

        // if let nbf = self.nbf {
        //     //            payload.nbf = nbf
        // }

        // let header = Header(cty: "twilio-fpa;v=1", typ: "JWT", twr: region)

        // let keys = try await JWTKeyCollection().add(jwksJSON: "")

        //        let jwt = try await keys.sign(payload, kid: "my-key")

        return try await keys.sign(self, kid: "my-key")
    }
}

// MARK: - AccessToken Options

struct AccessTokenOptions {
    var ttl: Int?
    var identity: String
    var nbf: Int?
    var region: String?
}

// MARK: - AccessToken Errors

enum AccessTokenError: Error {
    case invalidAccountSid
    case invalidKeySid
    case invalidSecret
    case invalidIdentity
    case unsupportedAlgorithm
}

// MARK: - Header

struct Header {
    let cty: String
    let typ: String
    let twr: String?

    //    func verify(using signer: JWTSigner) throws {}
}

// MARK: - Payload

//struct Payload: JWTPayload {
//    var jti: String
//    var grants: [String: Any]
//    var nbf: Int?
//
//    func verify(using signer: JWTSigner) throws {}
//}


struct TaskRouterGrant: Grant {
    let key = "task_router"
    var workspaceSid: String
    var workerSid: String
    var role: String

    init(workspaceSid: String, workerSid: String, role: String) {
        self.workspaceSid = workspaceSid
        self.workerSid = workerSid
        self.role = role
    }

    // func toPayload() -> [String: Any] {
    //     var grant: [String: Any] = [:]
    //     // if let workspaceSid = workspaceSid { grant["workspace_sid"] = workspaceSid }
    //     // if let workerSid = workerSid { grant["worker_sid"] = workerSid }
    //     // if let role = role { grant["role"] = role }
    //     return grant
    // }
}

// Repeat similarly for ChatGrant, VideoGrant, SyncGrant, VoiceGrant, PlaybackGrant...

struct ChatGrant: Grant {
    let key = "chat"
    var serviceSid: String?
    var endpointId: String?
    var deploymentRoleSid: String?
    var pushCredentialSid: String?

    init(
        serviceSid: String?, endpointId: String?, deploymentRoleSid: String?,
        pushCredentialSid: String?
    ) {
        self.serviceSid = serviceSid
        self.endpointId = endpointId
        self.deploymentRoleSid = deploymentRoleSid
        self.pushCredentialSid = pushCredentialSid
    }

    func toPayload() -> [String: Any] {
        var grant: [String: Any] = [:]
        if let serviceSid = serviceSid { grant["service_sid"] = serviceSid }
        if let endpointId = endpointId { grant["endpoint_id"] = endpointId }
        if let deploymentRoleSid = deploymentRoleSid {
            grant["deployment_role_sid"] = deploymentRoleSid
        }
        if let pushCredentialSid = pushCredentialSid {
            grant["push_credential_sid"] = pushCredentialSid
        }
        return grant
    }
}

// Repeat for VideoGrant, SyncGrant, VoiceGrant, PlaybackGrant...
