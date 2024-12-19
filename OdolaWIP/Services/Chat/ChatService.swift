//
//  ChatService.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import Foundation

protocol ChatServiceProtocol {
    func sendMessage(_ chatMessage: ChatMessage, isRetry: Bool) async throws -> ChatMessage
}
