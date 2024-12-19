//
//  MockChatService.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import Foundation

enum MockChatError: Error {
    case failedToSend
}

class MockChatService: ChatServiceProtocol {
    func sendMessage(_ chatMessage: ChatMessage, isRetry: Bool = false) async throws -> ChatMessage {
        // Mock the logic of an chatbot
        if chatMessage.message.lowercased().contains("status") {
            // Status of a transaction
            return ChatMessage(id: UUID().uuidString,
                               message: "The status of that transaction is \"Pending.\" Is there anything else I can help you with?",
                               role: .assistant,
                               created: Date())
        } else if chatMessage.message.lowercased().contains("best time")
                    && chatMessage.message.lowercased().contains("send")
                    && chatMessage.message.lowercased().contains("payment") {
            // Best time to send a payment to the Philippines
            let calendar = Calendar.current
            let today = Date()
            let startDate = calendar.date(byAdding: .day, value: 9, to: today)!
            let endDate = calendar.date(byAdding: .day, value: 12, to: today)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            let formattedStartDate = dateFormatter.string(from: startDate)
            let formattedEndDate = dateFormatter.string(from: endDate)
            
            let message = "It looks like you'll receive the best rates between \(formattedStartDate) and \(formattedEndDate)."
            
            return ChatMessage(id: UUID().uuidString,
                               message: message,
                               role: .assistant,
                               created: Date())
        } else if chatMessage.message.lowercased().contains("weather") && !isRetry {
            throw MockChatError.failedToSend
        } else {
            return ChatMessage(id: UUID().uuidString,
                               message: "Unfortunately, I do not have the answer to that, but you can email support at suport@odola.com",
                               role: .assistant, 
                               created: Date())
        }
    }
}
