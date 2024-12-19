//
//  ChatTests.swift
//  OdolaWIPTests
//
//  Created by Jon Huynh on 12/18/24.
//

import XCTest
@testable import OdolaWIP

final class ChatTests: XCTestCase {
    
    var viewModel: ChatViewModel!
    var mockService: MockChatService!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockChatService()
        viewModel = ChatViewModel(service: mockService)
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }
    
    @MainActor
    func testSendMessageWithStatus() async throws {
        let message = ChatMessage(id: UUID().uuidString, message: "What is the status of my transaction?", role: .user, created: Date())
        
        await viewModel.sendMessage(message)
        
        XCTAssertEqual(viewModel.allChatMessages.count, 2)
        XCTAssertEqual(viewModel.allChatMessages.last?.message, "The status of that transaction is \"Pending.\" Is there anything else I can help you with?")
    }
    
    @MainActor
    func testSendMessageWithBestTimeToSendPayment() async throws {
        let message = ChatMessage(id: UUID().uuidString, message: "What's the best time to send a payment to the Philippines?", role: .user, created: Date())
        
        await viewModel.sendMessage(message)
        
        XCTAssertEqual(viewModel.allChatMessages.count, 2)
        if let lastMessage = viewModel.allChatMessages.last?.message.lowercased() {
            XCTAssertTrue(lastMessage.contains("best rates between"))
        }
    }
    
    @MainActor
    func testSendMessageThatFailsAndRetries() async throws {
        let initialMessage = ChatMessage(id: UUID().uuidString, message: "How's the weather?", role: .user, created: Date())
        
        await viewModel.sendMessage(initialMessage)
        
        XCTAssertEqual(viewModel.allChatMessages.count, 1)
        XCTAssertEqual(viewModel.allChatMessages.first?.didSendSuccessfully, false)
        
        viewModel.selectedFailedChatMessage = viewModel.allChatMessages.first
        let failedMessage = viewModel.selectedFailedChatMessage!
        
        await viewModel.sendMessage(failedMessage, isRetry: true)
        
        XCTAssertEqual(viewModel.allChatMessages.count, 2)
        
        guard let matchedFailedMessage = viewModel.allChatMessages.first(where: { $0.id == failedMessage.id }) else {
            XCTFail("Unable to find matching failed message")
            return
        }
        XCTAssertNil(matchedFailedMessage.didSendSuccessfully)
        
        guard let lastMessage = viewModel.allChatMessages.last?.message.lowercased() else {
            XCTFail("Unable to unwrap last message")
            return
        }
        XCTAssertTrue(lastMessage.contains("unfortunately"))
    }
}
