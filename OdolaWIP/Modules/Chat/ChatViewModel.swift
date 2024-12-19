//
//  ChatViewModel.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var isSendingMessage: Bool = false
    @Published var allChatMessages: [ChatMessage] = []
    @Published var selectedFailedChatMessage: ChatMessage?
    
    let service: ChatServiceProtocol
    
    init(service: ChatServiceProtocol) {
        self.service = service
    }
    
    var sortedChatMessages: [ChatMessage] {
        return allChatMessages.sorted(by: { $0.created < $1.created })
    }
    
    func startChatSupport() async {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation {
                self.allChatMessages.append(
                    ChatMessage(
                        id: UUID().uuidString,
                        message: "Hi Abdigani, how can I help you today?",
                        role: .assistant,
                        created: Date()
                    )
                )
            }
        }
    }
    
    func sendMessage(_ message: ChatMessage, isRetry: Bool = false) async {
        do {
            defer {
                hideTypingIndicator()
            }
            
            if isRetry {
                selectedFailedChatMessage = nil
                self.deleteMessage(id: message.id)
                var tempMessage = message
                tempMessage.didSendSuccessfully = nil
                tempMessage.created = Date()
                displayMessage(tempMessage)
            } else {
                // Add user message to feed
                displayMessage(message)
            }
            
            // Show typing indicator
            showTypingIndicator()
            try await Task.sleep(nanoseconds: 3_000_000_000)
            
            // Perform request
            let responseMessage = try await service.sendMessage(message, isRetry: isRetry)
            
            displayMessage(responseMessage)
        } catch {
            var failedMessage = message
            failedMessage.didSendSuccessfully = false
            self.updateMessage(withId: message.id, to: failedMessage)
        }
    }
    func displayMessage(_ message: ChatMessage) {
        withAnimation {
            self.allChatMessages.append(message)
        }
    }
    func showTypingIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            withAnimation {
                self?.isSendingMessage = true
            }
        }
    }
    func hideTypingIndicator() {
        withAnimation {
            self.isSendingMessage = false
        }
    }
    func updateMessage(withId id: String, to message: ChatMessage) {
        if let index = allChatMessages.firstIndex(where: { $0.id == id }) {
            withAnimation {
                allChatMessages[index] = message
            }
        }
    }
    func deleteMessage(id: String) {
        if let index = allChatMessages.firstIndex(where: { $0.id == id }) {
            selectedFailedChatMessage = nil
            withAnimation {
                _ = allChatMessages.remove(at: index)
            }
        }
    }
}
