//
//  TransactionsTests.swift
//  OdolaWIPTests
//
//  Created by Jon Huynh on 12/18/24.
//

import XCTest
@testable import OdolaWIP

final class TransactionsTests: XCTestCase {

    var viewModel: HomeViewModel!
    var repository: TransactionRepository!
    var mockService: MockTransactionService!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockTransactionService()
        repository = TransactionRepository(service: mockService)
        viewModel = HomeViewModel(repository: repository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    @MainActor
    func testAllTransactionsDecodeCorrectly() async {
        await viewModel.getTransactions()
        XCTAssertEqual(viewModel.allTransactions.count, 7, "Expected allTransactions to contain 7 transactions.")
    }

    @MainActor
    func testTransactionsGroupedCorrectly() async throws {
        await viewModel.getTransactions()
        let grouped = viewModel.groupedTransactions
        
        XCTAssertEqual(grouped.keys.count, 6, "Expected 6 unique date groups.")
        XCTAssertEqual(grouped["Mon, Dec 16"]?.count, 2, "Expected 2 transactions for Dec 16.")
        XCTAssertEqual(grouped["Fri, Dec 13"]?.first?.title, "Chipotle", "Expected 'Chipotle' for Dec 13.")
    }
    
    @MainActor
    func testDateSortedFromMostRecentToEarliest() async throws {
        await viewModel.getTransactions()
        let sortedDates = viewModel.sortedDates
        
        XCTAssertEqual(sortedDates.first, "Mon, Dec 16", "Expected Dec 16 to be the most recent date.")
        XCTAssertEqual(sortedDates.last, "Mon, Dec 09", "Expected Dec 09 to be the earliest date.")
    }
}
