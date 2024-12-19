//
//  TransactionRepository.swift
//  OdolaWIP
//
//  Created by Jon Huynh on 12/19/24.
//

import Foundation

final class TransactionRepository {
    private let service: TransactionServiceProtocol

    init(service: TransactionServiceProtocol) {
        self.service = service
    }

    func getTransactions(networkAvailable: Bool) async throws -> [ODLTransaction] {
        if networkAvailable {
            let transactions = try await service.getTransactions()
            let data = try JSONEncoder().encode(transactions)
            UserDefaults.standard.set(data, forKey: "cachedTransactions")
            return transactions
        } else {
            if let cachedData = UserDefaults.standard.data(forKey: "cachedTransactions"),
               let cachedTransactions = try? JSONDecoder().decode([ODLTransaction].self, from: cachedData) {
                return cachedTransactions
            } else {
                throw NSError(domain: "No Cached Data", code: -1, userInfo: nil)
            }
        }
    }
}
