//
//  ChatMessage.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import Foundation

struct ChatMessage: Equatable, Codable {
    let id: String
    let message: String
    let role: ChatRole
    var created: Date
    var didSendSuccessfully: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case message
        case role
        case created
    }
    
}

enum ChatRole: String, Codable {
    case assistant
    case user
}
