//
//  MockTransactionService.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/17/24.
//

import Foundation

class MockTransactionService: TransactionServiceProtocol {
    func getTransactions() async throws -> [ODLTransaction] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return try MockDataLoader.load(from: "mock_transactions", type: AllTransactions.self).transactions
    }
}
