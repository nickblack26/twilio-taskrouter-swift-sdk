//
//  File.swift
//  TwilioTaskrouterSwift
//
//  Created by Nick Black on 12/6/24.
//

import Foundation
import FlexEmit

protocol Subscribable {
    var eventEmitter: Emitter { get }
    
}
