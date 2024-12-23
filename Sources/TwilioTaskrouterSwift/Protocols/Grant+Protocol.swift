//
//  File.swift
//  TwilioTaskrouterSwift
//
//  Created by Nick Black on 11/12/24.
//

import Foundation

// MARK: - Grant Protocol & Implementations
protocol Grant: Codable, Sendable {
    var key: String { get }
    // func toPayload() -> [String: Any]
}
